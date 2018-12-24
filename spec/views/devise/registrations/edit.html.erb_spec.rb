require 'rails_helper'

describe "devise/registrations/edit" do

  let(:user) { FactoryBot.create(:user) }

  it "renders the edit registrations form" do
    render template: 'devise/registrations/edit', locals: {
      resource: user
    }

    assert_select "form[action=?][method=?]", user_registration_path, "post" do
      assert_select "input[name*=name][value=?]",   user.name
      assert_select "textarea[name*=description]",  ""
      assert_select "input[name*=email][value=?]",  user.email
      assert_select "input[name*=phone][value=?]",  user.phone
    end
  end

  context "when the user has a location" do

    it "exposes those values" do
      location = FactoryBot.create(:location, user: user)
      user.reload

      render template: 'devise/registrations/edit', locals: {
        resource: user
      }

      # TODO: should have the location values :-/ but will be moving to profile soon
      assert_select "input[name*=latitude]",        1
      assert_select "input[name*=longitude]",       1

      assert_select "input[name*=name][value=?]",   location.name
      assert_select "textarea[name*=description]",  location.description
      assert_select "input[name*=email][value=?]",  user.email
      assert_select "input[name*=phone][value=?]",  user.phone
    end
  end

end
