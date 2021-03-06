require 'rails_helper'


describe User do
  describe "validations" do
    let(:user) { FactoryBot.build(:user) }

    it "validates presence of name" do
      expect(user).to be_valid
      user.name = ""
      expect(user).to be_invalid
      expect(user.errors[:name].size).to eq(1)
    end
  end

  describe "#prompt_additional_information?" do
    let(:user) { FactoryBot.build(:user) }

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

  describe '#facebook_identity' do
    let(:user) { FactoryBot.create(:user) }
    let!(:identity) { FactoryBot.create(:identity, user: user) }

    it 'returns identity with provider facebook' do
      expect(user.facebook_identity).to eq identity
    end
  end

  describe '#is_facebook_user?' do
    let(:user) { FactoryBot.create(:user) }

    context 'user has no facebook identity' do
      it 'returns false' do
        expect(user.is_facebook_user?).to be false
      end
    end

    context 'user has facebook identity' do
      let!(:identity) { FactoryBot.create(:identity, user: user) }

      it 'returns true' do
        expect(user.is_facebook_user?).to be true
      end
    end
  end

  describe '#latest_coordinate' do
    let(:user) { FactoryBot.create(:user) }
    let!(:coordinates) { FactoryBot.create_list(:coordinate, 3, user: user) }

    it 'returns latest coordinate of user' do
      expect(user.latest_coordinate.id).to eq Coordinate.order(:created_at).last.id
    end
  end

  describe "#email" do 
    let(:user) { FactoryBot.build :user,  email: 'change@me-123-facebook.com' }
    it "doesn't show the facebook fake email" do
      expect(user).to be_valid
      expect(user.email).to eq('')

      user.email = 'tommy@example.com'
      expect(user.email).to eq('tommy@example.com')
    end
  end
end

