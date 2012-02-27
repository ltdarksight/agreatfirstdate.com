class Profile < ActiveRecord::Base
  GENDERS = {male: 'man', female: 'woman'}

  belongs_to :user
  has_many :pillars
  has_many :pillar_categories, through: :pillars
  has_many :event_items, through: :pillars, :dependent => :destroy
  has_many :event_photos, :dependent => :destroy
  has_many :avatars
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :favorite

  delegate :email, to: :user

  before_validation :limit_avatars

  accepts_nested_attributes_for :avatars, allow_destroy: true
  accepts_nested_attributes_for :favorites, allow_destroy: true

  validates :who_am_i, length: {maximum: 500}
  validates :who_meet, length: {maximum: 500}

  def limit_avatars
    new_avatars = avatars.reject(&:marked_for_destruction?)
    new_avatars[Avatar::LIMIT..new_avatars.count].each(&:mark_for_destruction) if new_avatars.count > 3
  end

  def looking_for_age_from
    looking_for_age.blank? ? 18 : looking_for_age.split('-').first.to_i
  end

  def looking_for_age_to
    looking_for_age.blank? ? 50 : looking_for_age.split('-').last.to_i
  end

  def self.search_conditions(params)
    profiles = Arel::Table.new(:profiles)
    users = Arel::Table.new(:users)
    pillars = Arel::Table.new(:pillars)
    pillar_categories = Arel::Table.new(:pillar_categories)

    by_term = profiles.
        join(users).on(profiles[:user_id].eq(users[:id])).
        join(pillars, Arel::Nodes::OuterJoin).on(pillars[:profile_id].eq(profiles[:id])).
        join(pillar_categories, Arel::Nodes::OuterJoin).on(pillars[:pillar_category_id].eq(pillar_categories[:id])).

        where(profiles[:gender].eq(params[:looking_for]).or(profiles[:gender].eq(nil))).
        where(profiles[:looking_for].eq(params[:gender]).or(profiles[:looking_for].eq(nil))).
        where(profiles[:in_or_around].eq(params[:in_or_around]).or(profiles[:in_or_around].eq(nil)))


    by_term = by_term.where(profiles[:age].gteq(params[:looking_for_age_from]).or(profiles[:age].eq(nil))) unless params[:looking_for_age_from].blank?
    by_term = by_term.where(profiles[:age].lteq(params[:looking_for_age_to]).or(profiles[:age].eq(nil))) unless params[:looking_for_age_from].blank?
        #where(Arel.sql(%{})).

    unless params[:pillar_category_ids].blank?
      by_term = by_term.where(pillar_categories[:id].in(params[:pillar_category_ids]))
      by_term = by_term.having("COUNT(pillar_categories.id) >= #{params[:pillar_category_ids].count}") if 'all' == params[:match_type]
    end
    by_term.group(self.columns_list).project('profiles.*, COUNT(pillar_categories.id)')
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
    "#{first_name} #{last_name.first}."
  end

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:include] ||= []
    options[:methods] ||= []
    options[:only] = :id, :first_name, :last_name, :age, :gender, :in_or_around, :looking_for, :looking_for_age
    options[:include] += [:avatars]

    case options[:scope]
      when :search_results
      when :search
        options[:methods] += [:looking_for_age_from, :looking_for_age_to, :pillar_category_ids]
        options[:include] += [:favorites, :favorite_users]
      when :profile
        options[:only] += [:points, :who_am_i, :who_meet]
      when :self
        options[:only] += [:points, :who_am_i, :who_meet]
        options[:include] += [:favorites, :favorite_users]
      else
    end

    options[:methods] += [:short_name]

    hash = super
    hash[:pillars] = pillars.map { |p| p.serializable_hash scope: options[:scope] }
    hash
  end

  def can_send_emails?
    points >= 100
  end
end
