class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)
    profile = user.profile || Profile.new

    if user.admin?
      can :activate, Profile
      can :deactivate, Profile
      can :activate, EventItem
      can :deactivate, EventItem
      can :view, Profile
      can :update, InappropriateContent
    end

    #Avatar
    can :update, Avatar do |avatar|
      avatar.profile == profile
    end

    #EventItem
    can :create, EventItem do |event|
      profile.pillars.include? event.pillar
    end

    can :update, EventItem do |event|
      profile.event_items.include? event
    end

    #Profile
    can :view, Profile do |current_profile|
      current_profile.active? && profile.pillars_count > 0
    end

    can :update, Profile do |current_profile|
      current_profile.id == profile.id
    end

    #Email
    can :create, Email do |email|
      profile.can_send_emails?
    end

    #InappropriateContent
    can :update, InappropriateContent do |inappropriate_content|
      profile.inappropriate_content == inappropriate_content
    end
  end
end
