require 'rails_helper'

describe "layouts/application" do

  it "renders the default title" do
    render template: 'layouts/application', locals: { }
    assert_select "title", "Location Machine"
  end

  context "when there is a Setting for the Site Title" do
    let!(:setting) { Setting.create name: 'site.title', value: 'Home Food Map' }

    it "renders the setting's title" do
      render template: 'layouts/application'
      assert_select "title", setting.value
    end
  end

  context "when there is a Setting for the Custom HTML" do
    let!(:setting) { Setting.create name: 'site.custom-html', value: <<-HTML }
    <style>.homepage_logo { display: none; }</style>
    HTML

    it "renders the setting's title" do
      render template: 'layouts/application'
      expect(rendered).to include('<style>.homepage_logo')
    end
  end

end
