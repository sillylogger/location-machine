require 'rails_helper'

describe "Admin Pages" do
  include_examples 'admin login'

  it "lets you create new pages through active_admin" do
    # expect {
    #   visit "/privacy-policy"
    #   expect(page).to have_content("RoutingError")
    # }.to raise_error(ActionController::RoutingError)

    visit admin_pages_path
    expect(page.current_path).to include(admin_pages_path)

    click_link "New Page"
    wait_until { page.current_path.include?(new_admin_page_path) }

    fill_in     'page[title]',    with: "Privacy Policy"
    fill_in     'page[path]',     with: "privacy-policy"
    fill_in     'page[content]',  with: "# Privacy Policy \n Who we are; What personal data we collect and why we collect it"
    select      'Public',         from: 'page[visibility]'
    check       'page[published]'

    click_button 'Create Page'
    wait_until {
      custom_page = Page.last
      page.current_path.include?(admin_page_path(custom_page))
    }

    visit "/p/privacy-policy"
    expect(page).to have_content("Privacy Policy")
    expect(page).to have_content("Who we are; What personal data we collect and why we collect it")
  end

end
