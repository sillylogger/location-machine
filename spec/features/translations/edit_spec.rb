require "rails_helper"

describe "Translation Edit Page" do

  include_examples "admin login"

  it "lets admin edit translation through active_admin and see new translation in location show page" do
    translation = Translation.create(locale: "en", key: "lm.action.post", value: "test")

    visit edit_admin_translation_path(translation)

    expect(page.current_path).to eq edit_admin_translation_path(translation)

    fill_in     'i18n_backend_active_record_translation[value]', with: 'Post!'

    click_button 'Update Translation'

    wait_until { page.current_path.include?(admin_translation_path(translation)) }

    expect(page).to have_content 'Post!'

    visit root_path

    expect(page.current_path).to eq root_path
    expect(page).to have_content 'Post!'
  end
end
