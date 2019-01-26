require 'rails_helper'

describe "layouts/application" do

  let(:default_title) { "Location Machine" }

  it "renders the default title" do
    render template: 'layouts/application', locals: { }

    assert_select "title", default_title
    assert_select "header h2", default_title
  end

  context "when there is a Setting for the Site Title" do
    let!(:setting) { Setting.create name: 'site.title',
                                    value: 'Home Food Map' }

    it "renders the setting's title" do
      render template: 'layouts/application'

      assert_select "title", setting.value
      assert_select "header h2", setting.value
    end
  end

  context "when there is a Setting for the Site Logo" do
    let!(:setting) { Setting.create name: 'site.logo',
                                    value: "Logo's Alt",
                                    has_image: true,
                                    image: Rails.root.join("spec", "fixtures", "spring-rolls.jpg")
    }

    it "renders the setting's title" do
      debugger

      render template: 'layouts/application'

      assert_select "title", default_title
      assert_select "header h2", ""
      assert_select "header img[alt=?]", setting.value
    end
  end

end
