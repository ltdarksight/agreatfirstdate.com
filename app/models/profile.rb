class Profile < ActiveRecord::Base


  # attr_accessible :who_am_i, :who_meet, :avatars_attributes,
  #   :looking_for, :gender, :in_or_around, :looking_for_age

  GENDERS = {male: 'man', female: 'woman'}
  AGES = {"18-24" => [18, 24], "25-36" => [25, 36], "37-50" => [37, 50], "50 and over" => [50, 75]}
  LOCATIONS = ['Denver, CO']
  CARD_TYPES = ['Visa', 'MasterCard', 'American Express']
  STATUSES = %w[active locked]
  CARD_ATTRIBUTES = [:first_name, :last_name, :address1, :address2, :state, :city, :zip,
                     :card_number, :card_exp_month,  :card_exp_year, :card_cvc, :card_type, :stripe_card_token]
  ACCESSIBLE_ATTRIBUTES = [:who_am_i, :who_meet, :avatars_attributes, :gender,
      :looking_for_age, :looking_for_age_to, :looking_for_age_from,
      :in_or_around, :first_name, :last_name, :birthday, :looking_for,
      :canceled, :"birthday(1i)", :"birthday(2i)", :"birthday(3i)",
      :address1, :address2, :zip, :city, :state,
      :card_number, :card_type, :card_exp_month,  :card_exp_year, :card_cvc, :discount_code,
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

  before_validation :format_card_info
  before_validation :limit_avatars

  before_update :set_age, if: :birthday?
  # before_update :set_payment, if: :card_token_provided?

  accepts_nested_attributes_for :avatars, allow_destroy: true
  accepts_nested_attributes_for :favorites, allow_destroy: true
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :strikes

  validates :who_am_i, length: {maximum: 500}
  validates :who_meet, length: {maximum: 500}
  validates :card_number, format: {with: /^[0-9]+$/}, allow_blank: true
  validates :card_cvc, format: {with: /^[0-9]{3,4}$/}, allow_blank: true
  validates :card_exp_year, format: {with: /[0-9]{4}/}, allow_blank: true
  validates :card_exp_month, format: {with: /(0?[1-9]|1[0-2])/}, allow_blank: true
  #validate :valid_reset_pillar_categories

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
  after_customer_created! do |customer, event|
    if profile = find_by_stripe_customer_token(customer.id)
      profile.update_attribute :customer_status, true
    end
  end

  after_customer_deleted! do |customer, event|
    if profile = find_by_stripe_customer_token(customer.id)
      profile.update_attribute :customer_status, false
    end
  end

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
      UserMailer.charge_succeeded(profile).deliver
    end
  end

  after_charge_failed! do |charge, event|
    if profile = Profile.find_by_stripe_customer_token(charge.customer)
      UserMailer.charge_failed(profile).deliver
    end
  end
  #  END STRIPE CALLBACK =======================================================

#  def valid_reset_pillar_categories
 #   errors.add(:pillars, "Too many pillars selected") if pillar_categories.length > 4
  #  unless pillars_changed_at.nil? || (pillars_changed_at && pillars_changed_at < 1.month.ago)
   #   if points < 300
    #    errors.add(:pillars, "You don't have 300 points!")
     # end
    #end

  #end
#  before_save :update_pillar_categories
  #def update_pillar_categories

  def activate!
    InappropriateContent.destroy_all(content_id: self.id, content_type: 'Profile')
    reload
  end

  def deactivate!(reason = nil)
    InappropriateContent.create(content: self, reason: reason)
    reload
  end

  def pillar_category_ids=(_ids)
#    unless pillars_changed_at.nil? || (pillars_changed_at && pillars_changed_at < 1.month.ago)
#      self.poins = self.point - 300
#    end
#    super _ids
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

  def card_token_provided?
    !stripe_card_token.blank?
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

  def self.search_conditions(params, current_user, limit, result_ids)
    profiles = Arel::Table.new(:profiles)
    users = Arel::Table.new(:users)
    pillars = Arel::Table.new(:pillars)
    pillar_categories = Arel::Table.new(:pillar_categories)
    strikes = Arel::Table.new(:strikes)

    by_term = profiles.
        join(users).on(profiles[:user_id].eq(users[:id])).
        join(pillars).on(pillars[:profile_id].eq(profiles[:id])).
        join(pillar_categories).on(pillars[:pillar_category_id].eq(pillar_categories[:id])).
        where(profiles[:gender].eq(params[:looking_for]).or(profiles[:gender].eq(nil))).
        where(profiles[:looking_for].eq(params[:gender]).or(profiles[:looking_for].eq(nil))).
        where(profiles[:in_or_around].eq(params[:in_or_around]).or(profiles[:in_or_around].eq(nil)))

    if current_user
      exclude_profile_ids = Strike.joins(:striked).select("striked_id").where(profile_id: current_user.profile.id).
        group('striked_id').
        having("((count(striked_id) >= 3) or ( (max(strikes.created_at) > CURRENT_DATE) AND (max(strikes.created_at) > max(profiles.updated_at) ) ) )").map(&:striked_id)

      by_term = by_term.where( profiles[:id].not_in( exclude_profile_ids)) if exclude_profile_ids.present?

    end
    by_term = by_term.where(profiles[:status].eq('active')) if !current_user || !current_user.admin?

    by_term = by_term.where(profiles[:age].gteq(params[:looking_for_age_from]).or(profiles[:age].eq(nil))) unless params[:looking_for_age_from].blank?
    by_term = by_term.where(profiles[:age].lteq(params[:looking_for_age_to]).or(profiles[:age].eq(nil))) unless params[:looking_for_age_from].blank?
        #where(Arel.sql(%{})).
    if limit
      if limit == result_ids.size
        by_term = by_term.where(profiles[:id].in(result_ids))
      end
      by_term = by_term.order('RANDOM()').take(limit)
    end

    if params[:profile] && params[:profile][:pillar_category_ids]
      by_term = by_term.where(pillar_categories[:id].in(params[:profile][:pillar_category_ids]))
      by_term = by_term.having("COUNT(pillar_categories.id) >= #{params[:profile][:pillar_category_ids].count}") if 'all' == params[:match_type]
    end

    by_term.group(self.columns_list).project("profiles.*, COUNT(pillar_categories.id)")
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
    options[:only] = :id, :first_name, :last_name, :age, :gender, :in_or_around, :looking_for, :looking_for_age, :who_am_i, :who_meet, :status
    options[:include] += [:avatars]

    case options[:scope]
      when :search_results
        options[:only].delete :who_am_i
        options[:only].delete :who_meet
      when :search
        options[:only] += [:points]
        options[:methods] += [:looking_for_age_from, :looking_for_age_to, :pillar_category_ids, :card_verified?]
        options[:include] += [:favorites, :favorite_users, :strikes]
      when :profile
        options[:only] += [:points]
        options[:include] += [:inappropriate_content]
      when :self
        options[:only] += [:points]
        options[:methods] += [:role, :inappropriate_contents, :card_verified?, :card_provided?, :facebook_token, :facebook_id, :instagram_token]
        options[:include] += [:favorites, :favorite_users, :strikes, :inappropriate_content]
      when :settings
        options[:only] += [:points]
        options[:methods] += [:card_verified?, :card_provided?, :card_number_masked, :card_cvc_masked]
      else
    end

    options[:methods] += [:short_name]

    hash = super
    hash[:avatar] = avatars.random
    hash[:can_reset] = self.can_reset_pillar_categories?
    hash[:pillars] = pillars.map { |p| p.serializable_hash scope: options[:scope] }
    hash
  end

  def can_send_emails?
    active? && points >= 100
  end

  def card_number_masked
    mask_card_number card_number
  end

  def card_cvc_masked
    mask_card_cvc card_cvc
  end

  def format_card_info
    self.card_number = if card_number_changed?
      card_number.to_s.gsub(/[^0-9]/, '')
    else
      card_number_was
    end

    self.card_cvc = card_cvc_was unless card_cvc_changed?
  end

  def card_number_changed?
    mask_card_number(card_number_was) != card_number
  end

  def card_cvc_changed?
    mask_card_cvc(card_cvc_was) != card_cvc
  end

  def card_verified?
    true
    # card_provided? && customer_status? && customer_subscription_status? && invoice_status?
  end

  def card_provided?
    !stripe_customer_token.blank?
  end

  def lock!
    update_attribute(:status, :locked)
  end

  def unlock!
    update_attribute(:status, :active)
  end

  def reload_card_attributes!
    attrs = %w[card_number card_expiration card_type card_cvc]
    actual = self.class.where(id: id).select(attrs).first
    attrs.each do |attr|
      self[attr] = actual[attr]
    end
  end

  def upload_facebook_avatar(pid)
    if user.facebook_token
      graph = Koala::Facebook::API.new(user.facebook_token)
      photo = graph.fql_query("SELECT src_big FROM photo WHERE pid="+pid.to_s).first
      avatar = avatars.create :remote_image_url => photo['src_big']
    end

    avatar
  end

  def destroy_credit_card!
    stripe_customer = Stripe::Customer.retrieve(self.stripe_customer_token)
    stripe_customer.delete

    self.stripe_customer_token = nil
    self.card_number = nil
    self.card_exp_month = nil
    self.card_exp_year = nil
    self.card_cvc =  nil
    save(:validate => false)

  rescue Stripe::InvalidRequestError => e
    logger.error "[profile {self.id} #{Time.current}] Stripe error while delete customer: #{e.message}"
  end

  def save_with_payment
    if valid?
      unless self.stripe_customer_token.present?
        create_stripe_customer!
      end

      save!
    end

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :card_number, "There was a problem with your credit card."
    false
  end

  private

  def create_stripe_customer!
    customer_options = {
      email: email,
      card: stripe_card_token,
      plan: Stripe::Plans::FIRST_PLAN.to_s
    }

    if discount_code.present? &&
        ( Stripe::Coupon.retrieve(discount_code.to_s) rescue nil )
      customer_options[:coupon] = discount_code.to_s
    end

    customer = Stripe::Customer.create customer_options
    self.stripe_customer_token = customer.id

  end

  def mask_card_number(card_number)
    card_number.to_s.sub(/^([0-9]+)([0-9]{4})$/) { '*' * $1.length + $2 }.scan(/.{4}/).join(' ')
  end

  def mask_card_cvc(cvc_code)
    cvc_code.to_s.gsub(/([0-9])/,  '*')
  end

  def set_age
    now = DateTime.now
    age = now.year - birthday.year
    age -= 1 if(now.yday < birthday.yday)
    self.age = age
  end


end
