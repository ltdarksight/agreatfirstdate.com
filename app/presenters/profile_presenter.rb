class ProfilePresenter
  attr_accessor :profile

  def initialize(profile)
    @profile = profile
  end

  def to_json(options = {})
    @profile.to_json options
  end

end
