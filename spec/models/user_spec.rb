describe User do

  describe "#prompt_additional_information?" do
    it "bothers users if they have the temp email" do
      user = FactoryBot.create :user, email: "#{User::TEMP_EMAIL_PREFIX}-facebook.com",
                                       unconfirmed_email: '',
                                       phone: ''

      expect(user.prompt_additional_information?).to be true
    end

    it "doesn't bother users if they supplied an additional email" do
      user = FactoryBot.create :user, email: "#{User::TEMP_EMAIL_PREFIX}-facebook.com",
                                       unconfirmed_email: 'tommy@example.com',
                                       phone: ''

      expect(user.prompt_additional_information?).to be false
    end

    it "doesn't bother users if their email isn't temp" do
      user = FactoryBot.create :user, email: "tommy@example.com",
                                       unconfirmed_email: '',
                                       phone: ''

      expect(user.prompt_additional_information?).to be false
    end

    it "doesn't bother users if they gave a phone number" do
      user = FactoryBot.create :user, email: "#{User::TEMP_EMAIL_PREFIX}-facebook.com",
                                       unconfirmed_email: '',
                                       phone: '+62-123-1234-5678'

      expect(user.prompt_additional_information?).to be false
    end
  end

end
