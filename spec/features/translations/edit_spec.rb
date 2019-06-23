require "rails_helper"

describe "Translation Edit Page" do

  include_examples "admin login"

  it "lets admin edit translation through active_admin and see new translation in location new page" do
    translation = Translation.create(locale: "en", key: "lm.action.create", value: "test")

    visit edit_admin_translation_path(translation)

    expect(page.current_path).to eq edit_admin_translation_path(translation)

    fill_in     'i18n_backend_active_record_translation[value]', with: 'Address'

    click_button 'Update Translation'

    wait_until { page.current_path.include?(admin_translation_path(translation)) }

    expect(page).to have_content 'Address'

    visit new_location_path
    expect(page.find('input[name="commit"').value).to eq 'Address'
  end
end
