require "rails_helper"

describe "Locale" do
  include_examples "user login"

  before do
    Translation.create(locale: "vi", key: "lm.action.post", value: "Tạo Location")
    Translation.create(locale: "en", key: "lm.action.post", value: "Post")

    user.update preferred_locale: preferred_locale

    visit root_path
  end

  context "when user set locale" do
    context "when locale = vi" do
      let(:preferred_locale) { "vi" }

      it { expect(page).to have_content "Tạo Location" }
    end

    context "when locale = vi" do
      let(:preferred_locale) { "en" }

      it { expect(page).to have_content "Post" }
    end
  end
end
