class Profile::UpdatePillarCategories
  POINTS = 300
  CATEGORY_LIMIT = 4
  attr_reader :errors

  def initialize(profile, category_ids)
    @profile = profile
    @category_ids = category_ids || []
    @errors = []
  end

  def valid?
    case
    when @category_ids.blank?
      @errors << "Categories should not be blank"
    when @category_ids.size > CATEGORY_LIMIT
      @errors << "Too many pillars selected"
    when !@profile.can_reset_pillar_categories?
      @errors << "You don't have 300 points!"
    end

    @errors.blank?
  end

  def execute!

    @current_ids = @profile.pillars.map(&:pillar_category_id)
    return true if @current_ids.sort == @category_ids.sort

    @ids_to_remove = @current_ids - @category_ids

    @profile.decrement! :points, POINTS
    @profile.update_attribute :pillars_changed_at, Time.current
    @profile.pillars.where(:pillar_category_id => @ids_to_remove).update_all(:active => false)

    (@category_ids - @current_ids).each do |added_id|
      pillar = @profile.pillars.inactive.where(:pillar_category_id => added_id).first_or_initialize
      pillar.update_attribute :active, true
    end

  end

end