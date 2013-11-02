class Profile < ActiveRecord::Base
  obfuscatable

  GENDERS = {male: 'man', female: 'woman'}
  AGES = {"18-24" => [18, 24], "25-36" => [25, 36], "37-50" => [37, 50], "50 and over" => [50, 75]}
  LOCATIONS = ['Denver, CO']
  STATUSES = %w[active locked]
  CARD_ATTRIBUTES = [:first_name, :last_name, :address1, :address2, :state, :city, :zip,
                     :card_type, :stripe_card_token, :card_exp_month, :card_exp_year]
  ACCESSIBLE_ATTRIBUTES = [:who_am_i, :who_meet, :avatars_attributes, :gender,
      :looking_for_age, :looking_for_age_to, :looking_for_age_from,
      :in_or_around, :first_name, :last_name, :birthday, :looking_for,
      :canceled, :"birthday(1i)", :"birthday(2i)", :"birthday(3i)",
      :address1, :address2, :zip, :city, :state,
      :card_type, :discount_code, :card_exp_month, :card_exp_year,
      :favorites_attributes, :user_attributes, :strikes_attributes, :billing_full_name, :country]

  attr_accessor :stripe_card_token, :canceled

  belongs_to :user

  has_many :pillars, dependent: :destroy
  has_many :pillar_categories, through: :pillars
  has_many :event_items, through: :pillars, dependent: :destroy
  has_many :event_photos, dependent: :destroy
  has_many :avatars, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :favorite
  has_many :strikes, dependent: :destroy do
    def can?(user_profile_id)
      !today.where(striked_id: user_profile_id).exists?
    end
  end
  has_many :point_tracks, class_name: 'Point', dependent: :destroy
  has_many :inappropriate_contents, through: :event_items, as: :content

  has_one :inappropriate_content, as: :content
  has_one :search_cache

  delegate :email, :role, :facebook_token, :facebook_id, :instagram_token, to: :user

  before_validation :limit_avatars

  before_update :set_age, if: :birthday?
  before_update :set_update_at!

  accepts_nested_attributes_for :avatars, allow_destroy: true
  accepts_nested_attributes_for :favorites, allow_destroy: true
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :strikes

  validates :who_am_i, length: {maximum: 500}
  validates :who_meet, length: {maximum: 500}
  validates :card_exp_year, format: {with: /[0-9]{4}/}, allow_blank: true
  validates :card_exp_month, format: {with: /(0?[1-9]|1[0-2])/}, allow_blank: true

  BILLING_FIELDS = [:billing_full_name, :address1, :city, :state, :zip, :country]
  validates *BILLING_FIELDS, presence: true, if: :stripe_customer_token?

  with_options :presence => true, :on => :update, :unless => :stripe_card_token do |model|
    model.validates :gender, :looking_for, :inclusion => { :in => GENDERS.keys.map(&:to_s) }
    model.validates :first_name, :last_name, :birthday
  end

  scope :active, where(status: 'active')

  STATUSES.each do |s|
    define_method("#{s}?") { status == s }
  end

  # STRIPE CALLBACK ============================================================
  include Stripe::Callbacks

  # after_customer_created! do |customer, event|
  #   if profile = find_by_stripe_customer_token(customer.id)
  #     profile.update_attribute :customer_status, true
  #   end
  # end

  # after_customer_deleted! do |customer, event|
  #   if profile = find_by_stripe_customer_token(customer.id)
  #     profile.update_attribute :customer_status, false
  #   end
  # end

  after_customer_subscription_created! do |subscription,  event|
    if profile = Profile.find_by_stripe_customer_token(subscription.customer)
      profile.update_attribute :customer_subscription_status, true
    end
  end

  after_customer_subscription_deleted! do |subscription,  event|
    if profile = Profile.find_by_stripe_customer_token(subscription.customer)
      profile.update_attribute :customer_subscription_status, false
    end
  end

  after_invoice_created! do |invoice,  event|
    if profile = Profile.find_by_stripe_customer_token(invoice.customer)
      profile.update_attribute :invoice_status, true
    end
  end
  after_invoice_payment_succeeded! do |invoice,  event|
    if profile = Profile.find_by_stripe_customer_token(invoice.customer)
      profile.update_attribute :invoice_status, true
    end
  end
  after_invoice_payment_failed! do |invoice,  event|
    if profile = Profile.find_by_stripe_customer_token(invoice.customer)
      profile.update_attribute :invoice_status, false
    end
  end

  after_charge_succeeded do |charge, event|
    if profile = Profile.find_by_stripe_customer_token(charge.customer)
      # Temporary disable mail sending
      # UserMailer.charge_succeeded(profile).deliver
    end
  end

  after_charge_failed! do |charge, event|
    if profile = Profile.find_by_stripe_customer_token(charge.customer)
      #UserMailer.charge_failed(profile).deliver
    end
  end
  #  END STRIPE CALLBACK =======================================================

  def new_profile?
    self.created_at == self.updated_at
  end

  def to_param
    self.obfuscated_id
  end

  def set_update_at!
    if changed.any?{|v| ACCESSIBLE_ATTRIBUTES.include?(v.to_sym) }
      self.profile_updated_at = Time.current
    end
  end

  def activate!
    InappropriateContent.destroy_all(content_id: self.id, content_type: 'Profile')
    reload
  end

  def deactivate!(reason = nil)
    InappropriateContent.create(content: self, reason: reason)
    reload
  end

  def canceled
    status == 'canceled'
  end

  def canceled=(value)
    self.status = value =='1' ? 'canceled' : 'active'
  end

  def cancel!
    update_attribute :status, "canceled"
    AdminMailer.cancel_account(self).deliver
  end

  def can_reset_pillar_categories?
    pillars_changed_at.nil? ||
    (pillars_changed_at && pillars_changed_at < 1.month.ago) || points >= 300
  end

  def set_active_pillars(ids)
    @update_pillar_categories = Profile::UpdatePillarCategories.new(self, ids.map(&:to_i))

    if @update_pillar_categories.valid? && @update_pillar_categories.execute!
      true
    else
      errors[:pillars] = @update_pillar_categories.errors.join(", ")
    end
  end

  def limit_avatars
    new_avatars = avatars.reject(&:marked_for_destruction?)
    new_avatars[Avatar::LIMIT..new_avatars.count].each(&:mark_for_destruction) if new_avatars.count > 3
  end

  # Methods for back compability
  attr_accessor :looking_for_age

  def looking_for_age
    [looking_for_age_from, looking_for_age_to].join "-"
  end

  def looking_for_age=(value)
    self.looking_for_age_from = (AGES[value] || value.to_s.split('-')).first.to_i
    self.looking_for_age_to = (AGES[value] || value.to_s.split('-')).last.to_i
  end

  def striked_profile_ids
    Strike.joins(:striked).where(profile_id: self.id).
      where(%q{
        strikes_count >= 3 OR
        striked_on = CURRENT_DATE OR
        (striked_on < CURRENT_DATE AND DATE(profiles.profile_updated_at) < strikes.striked_on)
      }).pluck(:striked_id)
  end

  def self.search_result_ids(params, current_user, limit)
    scoped_term = self.joins(:user, :pillars, :pillar_categories).
      where('profiles.gender = ? OR profiles.gender IS NULL', params[:looking_for]).
      where('profiles.looking_for = ? OR profiles.looking_for IS NULL', params[:gender]).
      where('profiles.in_or_around = ? OR profiles.in_or_around IS NULL', params[:in_or_around])

    if current_user
      exclude_profile_ids = current_user.profile.striked_profile_ids
      scoped_term = scoped_term.where('profiles.id NOT IN (?)', exclude_profile_ids) if exclude_profile_ids.present?
    end

    scoped_term = scoped_term.where('profiles.status = ?', 'active') if !current_user || !current_user.admin?

    scoped_term = scoped_term.where('profiles.age >= ? OR profiles.age IS NULL', params[:looking_for_age_from]) if params[:looking_for_age_from].present?
    scoped_term = scoped_term.where('profiles.age <= ? OR profiles.age IS NULL', params[:looking_for_age_to]) if params[:looking_for_age_to].present?

    if current_user
      if params[:match_type] == 'all'
        scoped_term = scoped_term.where("pillar_category_array @> ARRAY[?]", params[:pillar_category_ids])
      else
        scoped_term = scoped_term.where('pillar_categories.id IN (?)', params[:pillar_category_ids])
      end
    end

    scoped_term = scoped_term.order('RANDOM()').limit(limit) if limit

    scoped_term.group(self.columns_list).pluck("profiles.id")

  end

  def self.columns_list
    column_names.collect { |c| "#{table_name}.#{c}" }.join(",")
  end

  def self.find_records(*args)
    self.search_conditions(*args).group('companies.id').project('companies.*')
  end

  def self.find_records_count(*args)
    self.search_conditions(*args).project('COUNT(DISTINCT companies.id)')
  end

  def short_name
    "#{first_name.titleize} #{last_name.first.upcase}."
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:include] ||= []
    options[:methods] ||= []
    options[:only] = [
      :id, :first_name, :last_name, :age, :gender,
      :in_or_around, :looking_for,
      :who_am_i, :who_meet, :status,
      :birthday, :looking_for_age_from, :looking_for_age_to,
      :country
    ]
    options[:include] += [:avatars]

    case options[:scope]
    when :search_results
      options[:only].delete :who_am_i
      options[:only].delete :who_meet
    when :search
      options[:only] += [:points]
      options[:methods] += [:pillar_category_ids, :stripe_customer_token]
      options[:include] += [:favorites, :favorite_users, :strikes]
    when :profile
      options[:only] += [:points]
      options[:include] += [:inappropriate_content, :favorites, :favorite_users, :strikes]
    when :self
      options[:only] += [:points]
      options[:methods] += [:role, :inappropriate_contents, :stripe_customer_token, :facebook_token, :facebook_id, :instagram_token]
      options[:include] += [:favorites, :favorite_users, :strikes, :inappropriate_content]
    when :self_api
      options[:only] += [:points]
      options[:methods] += [:role, :inappropriate_contents, :stripe_customer_token, :facebook_token, :facebook_id, :instagram_token]
      options[:include] += [:favorites, :favorite_users, :strikes, :inappropriate_content]
    when :settings
      options[:only] += [:points]
      options[:methods] += [:card_type, :stripe_customer_token, :card_last4, :card_exp_month, :card_exp_year]
    else
    end

    options[:methods] += [:short_name]

    hash = super
    hash[:avatar] = avatars.random
    hash[:can_reset] = self.can_reset_pillar_categories?
    hash[:pillars] = pillars.map { |p| p.serializable_hash scope: options[:scope] }
    hash[:id] = self.to_param
    hash
  end

  def can_send_emails?
    active? && points >= 100
  end

  def card_type_to_image_name
    if card_type.present?
      card_type.parameterize
    else
      'visa'
    end
  end

  def lock!
    update_attribute(:status, :locked)
  end

  def unlock!
    update_attribute(:status, :active)
  end

  def upload_facebook_avatar(pid)
    if user.facebook_token
      graph = Koala::Facebook::API.new(user.facebook_token)
      photo = graph.fql_query("SELECT src_big FROM photo WHERE pid="+pid.to_s).first
      avatar = avatars.create :remote_image_url => photo['src_big']
    end

    avatar
  end

  def destroy_stripe_customer
    stripe_customer = Stripe::Customer.retrieve(stripe_customer_token)
    stripe_customer.delete

  rescue Stripe::InvalidRequestError => e
    clear_stripe_data
    logger.error "[profile {self.id} #{Time.current}] Stripe error while delete customer: #{e.message}"
  end

  def clear_stripe_data
      self.stripe_customer_token =  nil
      self.card_exp_month =         nil
      self.card_exp_year =          nil
      self.card_type =              nil
      save
  end

  def destroy_credit_card!
    destroy_stripe_customer
    save
  end

  def save_with_payment
    if valid?
      transaction do
        if stripe_card_token.present? || discount_code.present?
          destroy_stripe_customer if self.stripe_customer_token.present? && stripe_card_token.present?
          create_stripe_customer!
        end

        save
      end
    end

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  rescue Stripe::CardError => e
    logger.error "Stripe card error: #{ e.message }"
    errors.add :base, e.message
    false
  end

private
  def create_stripe_customer!
    customer_options = {
      email: email
    }

    if stripe_card_token.present?
      customer_options[:card] = stripe_card_token
      customer_options[:plan] = 'Monthly'
    end

    if discount_code.present? &&
        ( coupon = Stripe::Coupon.retrieve(discount_code.to_s) rescue nil )
      customer_options[:coupon] = coupon.id if coupon
    end

    puts customer_options.to_yaml

    if coupon && coupon.percent_off != 100 && !stripe_card_token.present?
      errors.add :card_number, "For current discount code credit card is required"
    else
      customer = Stripe::Customer.create customer_options
      self.stripe_customer_token = customer.id
      if stripe_card_token.present?
        self.card_type = customer.cards.data.first.type
        self.card_last4 = customer.cards.data.first.last4
        self.card_exp_month = customer.cards.data.first.exp_month
        self.card_exp_year = customer.cards.data.first.exp_year
      end
    end
  end

  def set_age
    now = DateTime.now
    age = now.year - birthday.year
    age -= 1 if(now.yday < birthday.yday)
    self.age = age
  end

  def set_default_country
    self.country = Country::DEFAULT if country.blank?
  end
end
