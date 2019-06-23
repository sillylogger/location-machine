require 'rails_helper'

describe Item do

  describe "#editor?" do
    let(:item) { FactoryBot.create(:item) }

    it "returns true for the location's user" do
      expect(item.editor?(item.location.user)).to be true
    end

    it "returns false for any other user" do
      visitor = FactoryBot.create(:user)
      expect(item.editor?(visitor)).to be false
    end

    it "returns false when no user is signed in" do
      expect(item.editor?(nil)).to be false
    end
  end

  describe "#price=" do
    let(:item) { FactoryBot.build(:item) }

    it "passes through the money parser to accept strings properly" do
      item.price = "19.00"
      expect(item.price).to eq(Money.new(19_00, "USD").amount)

      item.price = "$19.00"
      expect(item.price).to eq(Money.new(19_00, "USD").amount)

      item.price = "Rp50000"
      expect(item.price).to eq(Money.new(50_000_00, "IDR").amount)

      # item.price = "Rp50,000"
      # expect(item.price).to eq(Money.new(50_000_00, "IDR").amount)
      # This doesn't work, sigh :-(

      item.price = "Rp50.000,00"
      expect(item.price).to eq(Money.new(50_000_00, "IDR").amount)
    end
  end

  describe "#has_image?" do
    it "simply calls attached?" do
      item = FactoryBot.build(:item)
      expect(item).to_not have_image

      item = FactoryBot.create(:item, :with_image)
      expect(item).to have_image
    end
  end

  describe "#to_param" do
    it "includes the item name parameterized" do
      item = FactoryBot.create(:item)
      expect(item.to_param).to include(item.id.to_s)
      expect(item.to_param).to include(item.name.parameterize)
    end

    it "doesn't freak out if the name is nil" do
      item = FactoryBot.build(:item, name: nil)
      expect(item.to_param).to include(item.id.to_s)
    end
  end

  describe '.for_nearests' do
    let!(:item_1) { FactoryBot.create(:item, name: 'cake of Ba Ngoai') }
    let!(:item_2) { FactoryBot.create(:item, name: 'noodles', description: 'noodles and cake of 4P') }
    let!(:item_3) { FactoryBot.create(:item, name: 'pizza 4P') }
    let!(:item_4) { FactoryBot.create(:item, name: 'cake of Ba Noi') }
    let(:latitude) { -6.2189898 }
    let(:longitude) {106.7861758 }

    before do
      Location.update(latitude: latitude, longitude: longitude)
      item_4.location.update(latitude: 0, longitude: 0)
    end

    context 'no text' do
      it 'returns nearest items within distance 50' do
        expect(Item.for_nearests([latitude, longitude])).to match_array [item_1, item_2, item_3]
      end
    end

    context 'has text' do
      it 'returns nearest items within distance 50 with matched text' do
        expect(Item.for_nearests([latitude, longitude], text: 'cake')).to match_array [item_1, item_2]
      end
    end
  end
end
