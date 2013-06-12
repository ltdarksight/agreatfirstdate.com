class UserPresenter
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def to_json(options = {})
    @user.to_json options
  end

end
