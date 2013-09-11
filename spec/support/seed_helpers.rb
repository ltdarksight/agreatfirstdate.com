module SeedHelpers
  def create_user!(attributes={})
    user = create(:user, attributes)
    user
  end
end

RSpec.configure do |config|
  config.include SeedHelpers
end