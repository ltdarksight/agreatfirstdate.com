class Profile < ActiveRecord::Base
  GENDERS = {male: 'man', female: 'woman'}

  belongs_to :user
  has_many :avatars
  belongs_to :user
  has_many :pillars, through: :user

  accepts_nested_attributes_for :avatars, allow_destroy: true

  validates :who_am_i, length: {maximum: 500}
  validates :who_meet, length: {maximum: 500}

  def looking_for_age_from
    looking_for_age.split('_').first rescue 18
  end

  def looking_for_age_to
    looking_for_age.split('_').last rescue 35
  end

  def self.search_conditions(params)
    profiles = Arel::Table.new(:profiles)
    users = Arel::Table.new(:users)
    pillars = Arel::Table.new(:pillars)
    pillar_categories = Arel::Table.new(:pillar_categories)

    by_term = profiles.
        join(users).on(profiles[:user_id].eq(users[:id])).
        join(pillars, Arel::Nodes::OuterJoin).on(pillars[:user_id].eq(users[:id])).
        join(pillar_categories, Arel::Nodes::OuterJoin).on(pillars[:pillar_category_id].eq(pillar_categories[:id])).

        where(profiles[:gender].eq(params[:looking_for]).or(profiles[:gender].eq(nil))).
        where(profiles[:looking_for].eq(params[:gender]).or(profiles[:looking_for].eq(nil))).
        where(profiles[:in_or_around].eq(params[:in_or_around]).or(profiles[:in_or_around].eq(nil))).
        where(profiles[:age].gt(params[:looking_for_age_from]).or(profiles[:age].eq(nil))).
        where(profiles[:age].lt(params[:looking_for_age_to]).or(profiles[:age].eq(nil)))
        #where(Arel.sql(%{})).

    unless params[:pillar_ids].blank?
      by_term = by_term.where(pillar_categories[:id].in(params[:pillar_ids]))
      by_term = by_term.having("COUNT(pillar_categories.id) >= #{params[:pillar_ids].count}") if 'all' == params[:match_type]
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
    options[:include] += [:avatars, :pillars]
    options[:methods] = [:looking_for_age_from, :looking_for_age_to, :short_name]
    super
  end
end
