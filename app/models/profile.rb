class Profile < ActiveRecord::Base
  GENDERS = {male: 'man', female: 'woman'}
  AGES = {"18-24" => [18, 24], "25-36" => [25, 36], "37-50" => [37, 50], "50 and over" => [50, 75]}
  LOCATIONS = ['Denver, CO']
  CARD_TYPES = ['Visa', 'MasterCard', 'American Express']
  STATUSES = %w[active locked]
  CARD_ATTRIBUTES = [:first_name, :last_name, :address1, :address2, :state, :city, :zip,
                     :card_number, :card_expiration, :card_cvc, :card_type, :stripe_card_token]
  ACCESSIBLE_ATTRIBUTES = [:who_am_i, :who_meet, :avatars_attributes, :gender, :looking_for_age, :looking_for_age_to, :looking_for_age_from,
      :in_or_around, :first_name, :last_name, :birthday, :looking_for, :canceled, :"birthday(1i)", :"birthday(2i)", :"birthday(3i)",
      :address1, :address2, :zip, :city, :state,
      :card_number, :card_type, :card_expiration, :card_cvc,
      :favorites_attributes, :user_attributes, :strikes_attributes]

  attr_accessor :stripe_card_token, :canceled

  belongs_to :user
  has_many :pillars, dependent: :destroy
  has_many :pillar_categories, through: :pillars
  has_many :event_items, through: :pillars, dependent: :destroy
  has_many :event_photos, dependent: :destroy
  has_many :avatars, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :favorite
  has_many :strikes, dependent: :destroy
  has_many :point_tracks, class_name: 'Point', dependent: :destroy
  has_many :inappropriate_contents, through: :event_items, as: :content

  has_one :inappropriate_content, as: :content
  has_one :search_cache

  delegate :email, :role, :facebook_token, :facebook_id, to: :user

  before_validation :format_card_info
  before_validation :limit_avatars

  before_update :set_age, if: :birthday?
  before_update :set_payment, if: :card_token_provided?

  accepts_nested_attributes_for :avatars, allow_destroy: true
  accepts_nested_attributes_for :favorites, allow_destroy: true
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :strikes

  validates :who_am_i, length: {maximum: 500}
  validates :who_meet, length: {maximum: 500}
  validates :card_number, format: {with: /^[0-9]+$/}, allow_blank: true
  validates :card_cvc, format: {with: /^[0-9]{3,4}$/}, allow_blank: true
  validates :card_expiration, format: {with: /(0?[1-9]|1[0-2])\/[0-9]{2}/}, allow_blank: true

  with_options :presence => true, :on => :update, :unless => :stripe_card_token do |model|
    model.validates :gender, :looking_for, :inclusion => { :in => GENDERS.keys.map(&:to_s) }
    model.validates :first_name, :last_name, :birthday
  end

  scope :active, where(status: 'active')

  STATUSES.each do |s|
    define_method("#{s}?") { status == s }
  end

  def canceled
    status == 'canceled'
  end

  def canceled=(value)
    self.status = value =='1' ? 'canceled' : 'active'
  end

  def set_active_pillars(ids)
    ids.map!(&:to_i)
    if ids.size > 4
      errors[:pillars] = "Too many pillars selected"
      false
    else
      current_ids = pillars.map(&:pillar_category_id)
      ids_to_remove = current_ids - ids
      if ids_to_remove.present?
        if pillars_changed_at && pillars_changed_at > Time.now - 1.month
          if points < 300
            errors[:pillars] = "You don't have 300 points!"
            return false
          else
            decrement! :points, 300
          end
        else
          update_attribute :pillars_changed_at, Time.now
        end
        pillars.where(:pillar_category_id => ids_to_remove).update_all(:active => false)
      end

      (ids - current_ids).each do |added_id|
        pillar = pillars.inactive.where(:pillar_category_id => added_id).first_or_initialize
        pillar.update_attribute :active, true
      end

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
    self.looking_for_age_from = (AGES[value] || value.split('-')).first.to_i
    self.looking_for_age_to = (AGES[value] || value.split('-')).last.to_i
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
      by_term = by_term.join(strikes, Arel::Nodes::OuterJoin).on(profiles[:id].eq(strikes[:striked_id]).and(strikes[:profile_id].eq(current_user.profile.id))).
          having("COUNT(strikes.id)/(MAX(profiles.pillars_count)) < 3 AND (MAX(strikes.created_at) < CURRENT_DATE OR MAX(strikes.created_at) IS NULL)")
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

    unless params[:pillar_category_ids].nil?
      by_term = by_term.where(pillar_categories[:id].in(params[:pillar_category_ids]))
      by_term = by_term.having("COUNT(pillar_categories.id) >= #{params[:pillar_category_ids].count}") if 'all' == params[:match_type]
    end

    by_term.group(self.columns_list).project("profiles.*, COUNT(pillar_categories.id)#{", COUNT(strikes.id)" if current_user}")
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
        options[:methods] += [:role, :inappropriate_contents, :card_verified?, :facebook_token, :facebook_id]
        options[:include] += [:favorites, :favorite_users, :strikes, :inappropriate_content]
      when :settings
        options[:only] += [:points]
        options[:methods] += [:card_verified?, :card_provided?, :card_number_masked, :card_cvc_masked]
      else
    end

    options[:methods] += [:short_name]

    hash = super
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

  private

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

  def set_payment
    customer = Stripe::Customer.create(email: email, card: stripe_card_token, plan: 1)
    self.stripe_customer_token = customer.id
  end
end
