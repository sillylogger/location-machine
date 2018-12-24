require 'rails_helper'

describe User do

  let(:user) { FactoryBot.build(:user) }

  describe "validations" do
    it "validates presence of name" do
      expect(user).to be_valid
      user.name = ""
      expect(user).to be_invalid
      expect(user.errors[:name].size).to eq(1)
    end
  end

  describe "#prompt_additional_information?" do
    it "doesn't bother the users if they haven't supplied additional information" do
      expect(user.prompt_additional_information?).to be false
    end

    it "bother the users if they are missing their name" do
      user.name = ''
      expect(user.prompt_additional_information?).to be true
    end

    it "bothers the user if they are missing both emails (forcing them to confirm is another story)" do
      user = FactoryBot.build :user,  email: '',
                                      unconfirmed_email: ''
      expect(user.prompt_additional_information?).to be true

      user = FactoryBot.build :user,  email: 'tommy@example.com',
                                      unconfirmed_email: ''
      expect(user.prompt_additional_information?).to be false

      user = FactoryBot.build :user,  email: '',
                                      unconfirmed_email: 'tommy@example.com'
      expect(user.prompt_additional_information?).to be false
    end

    it "bothers the user if they haven't given a phone number" do
      user = FactoryBot.create :user, phone: ''
      expect(user.prompt_additional_information?).to be true
    end
  end

end

