require 'spec_helper'

describe "profiles/edit" do
  before(:each) do
    @profile = assign(:profile, stub_model(Profile,
      :user_id => 1,
      :who_am_i => "MyText",
      :first_name => "MyString",
      :last_name => "MyString",
      :gender => "MyString",
      :looking_for => "MyString",
      :in_or_around => "MyString",
      :age => "MyString"
    ))
  end

  it "renders the edit profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => profiles_path(@profile), :method => "post" do
      assert_select "input#profile_user_id", :name => "profile[user_id]"
      assert_select "textarea#profile_who_am_i", :name => "profile[who_am_i]"
      assert_select "input#profile_first_name", :name => "profile[first_name]"
      assert_select "input#profile_last_name", :name => "profile[last_name]"
      assert_select "input#profile_gender", :name => "profile[gender]"
      assert_select "input#profile_looking_for", :name => "profile[looking_for]"
      assert_select "input#profile_in_or_around", :name => "profile[in_or_around]"
      assert_select "input#profile_age", :name => "profile[age]"
    end
  end
end
