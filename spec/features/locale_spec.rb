require "rails_helper"

describe "Locale" do
  include_examples "user login"

  let!(:post_in_vietnamese) { Translation.create(locale: "vi", key: "lm.action.post", value: "Tạo Location") }
  let!(:post_in_english) {    Translation.create(locale: "en", key: "lm.action.post", value: "Post") }

  context "when the user has a :vi locale" do
    let(:user) { FactoryBot.create :user, locale: "vi" }

    it "shows the vietnamese text for posting and remembers their preference" do
      visit root_path
      expect(page).to have_content post_in_vietnamese.value

      visit edit_user_registration_path

      name, symbol = I18n::SELECT_COLLECTION.find{|o| o.last == :vi }
      expect(page).to have_select "user_locale", selected: name
    end
  end

  context "when the user has a :en locale" do
    let(:user) { FactoryBot.create :user, locale: "en" }

    it "shows the english text for posting and remembers their preference" do
      visit root_path
      expect(page).to have_content post_in_english.value

      visit edit_user_registration_path

      name, symbol = I18n::SELECT_COLLECTION.find{|o| o.last == :en }
      expect(page).to have_select "user_locale", selected: name
    end
  end

end
