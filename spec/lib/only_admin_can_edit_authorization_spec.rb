require 'rails_helper'

describe OnlyAdminCanEditAuthorization do

  describe "authorized?(action, subject = nil)" do
    let(:resource) { nil }
    let(:user) { FactoryBot.create(:user, role: User::ROLES[:admin] ) }

    let(:adapter) { OnlyAdminCanEditAuthorization.new(resource, user) }

    it "lets admins edit" do
      expect(adapter.authorized?(:read)).to be_truthy
      expect(adapter.authorized?(:create)).to be_truthy
      expect(adapter.authorized?(:update)).to be_truthy
      expect(adapter.authorized?(:destroy)).to be_truthy
    end

    context "when a partner" do
      let(:user) { FactoryBot.create(:user, role: User::ROLES[:partner] ) }

      it "lets them view, but not edit" do
        expect(adapter.authorized?(:read)).to be_truthy
        expect(adapter.authorized?(:create)).to be_falsey
        expect(adapter.authorized?(:update)).to be_falsey
        expect(adapter.authorized?(:destroy)).to be_falsey
      end
    end

    context "without any role" do
      let(:user) { FactoryBot.create(:user, role: nil ) }

      it "doesn't let them do anything" do
        expect(adapter.authorized?(:read)).to be_falsey
        expect(adapter.authorized?(:create)).to be_falsey
        expect(adapter.authorized?(:update)).to be_falsey
        expect(adapter.authorized?(:destroy)).to be_falsey
      end
    end
  end

end

