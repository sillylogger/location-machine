require 'rails_helper'

describe Identity, type: :model do
  describe '.facebook' do
    let!(:facebook_identity) { FactoryBot.create(:identity) }
    let!(:identity) { FactoryBot.create(:identity, provider: :twitter) }

    it 'return facebook identities only' do
      expect(Identity.facebook).to eq [facebook_identity]
    end
  end
end
