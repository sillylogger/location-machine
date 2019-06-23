require "rails_helper"

describe "Locale" do
  include_examples "user login"

  let!(:create_in_vietnamese) { Translation.create(locale: "vi", key: "lm.action.create", value: "Địa chỉ") }
  let!(:create_in_english) { Translation.create(locale: "en", key: "lm.action.create", value: "Address") }

  context "when the user has a :vi locale" do
    let(:user) { FactoryBot.create :user, locale: "vi" }

    it "shows the vietnamese text for address and remembers their preference" do
      visit new_location_path
      expect(page.find('input[name="commit"').value).to eq create_in_vietnamese.value

      visit edit_user_registration_path

      name, _ = I18n::SELECT_COLLECTION.find { |o| o.last == :vi }
      expect(page).to have_select "user_locale", selected: name
    end
  end

  context "when the user has a :en locale" do
    let(:user) { FactoryBot.create :user, locale: "en" }

    it "shows the english text for address and remembers their preference" do
      visit new_location_path
      expect(page.find('input[name="commit"').value).to eq create_in_english.value

      visit edit_user_registration_path

      name, _ = I18n::SELECT_COLLECTION.find { |o| o.last == :en }
      expect(page).to have_select "user_locale", selected: name
    end
  end
end
