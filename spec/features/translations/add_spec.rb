require 'rails_helper'

describe 'Translation Pages' do

  include_examples 'admin login'

  it "lets admin create new translation through active_admin and see new translation in location show page" do
    visit admin_translations_path
    expect(page.current_path).to include(admin_translations_path)

    click_link "New Translation"
    wait_until { page.current_path.include?(new_admin_translation_path) }

    select      'en', from: 'i18n_backend_active_record_translation[locale]'
    fill_in     'i18n_backend_active_record_translation[key]', with: 'lm.action.post'
    fill_in     'i18n_backend_active_record_translation[value]', with: 'Post!'

    click_button 'Create Translation'

    wait_until {
      translation = Translation.where(key: 'lm.action.post').first
      page.current_path.include?(admin_translation_path(translation))
    }

    expect(page).to have_content 'Post!'

    visit root_path
    expect(page.current_path).to include(root_path)

    expect(page).to have_content 'Post!'
  end
end
