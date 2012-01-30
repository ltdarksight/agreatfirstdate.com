require 'spec_helper'

describe "profiles/show" do
  before(:each) do
    @profile = assign(:profile, stub_model(Profile,
      :user_id => 1,
      :who_am_i => "MyText",
      :first_name => "First Name",
      :last_name => "Last Name",
      :gender => "Gender",
      :looking_for => "Looking For",
      :in_or_around => "In Or Around",
      :age => "Age"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Last Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Gender/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Looking For/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/In Or Around/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Age/)
  end
end
