require 'rails_helper'

describe Location do

  describe ".items" do
    it "destroys dependents" do
      location = FactoryBot.create(:location)
      item = FactoryBot.create(:item, location: location)

      expect {
        location.destroy
      }.to change(Item, :count).by(-1)
    end
  end

  describe ".for_display" do
    it "must have a latitude" do
      no_latitude = FactoryBot.build(:location, latitude: nil)
      no_latitude.save(validate: false)
      expect(Location.for_display).to_not include(no_latitude)

      blank_latitude = FactoryBot.build(:location, latitude: "")
      blank_latitude.save(validate: false)
      expect(Location.for_display).to_not include(blank_latitude)
    end

    it "must have a longitude" do
      no_longitude = FactoryBot.build(:location, longitude: nil)
      no_longitude.save(validate: false)
      expect(Location.for_display).to_not include(no_longitude)

      blank_longitude = FactoryBot.build(:location, longitude: "")
      blank_longitude.save(validate: false)
      expect(Location.for_display).to_not include(blank_longitude)
    end

    it "must have a name" do
      no_name = FactoryBot.build(:location, name: nil)
      no_name.save(validate: false)
      expect(Location.for_display).to_not include(no_name)

      blank_name = FactoryBot.build(:location, name: "")
      blank_name.save(validate: false)
      expect(Location.for_display).to_not include(blank_name)
    end
  end

  describe "#editor?" do
    let(:location) { FactoryBot.create(:location) }

    it "returns true for the location's user" do
      expect(location.editor?(location.user)).to be true
    end

    it "returns false for any other user" do
      visitor = FactoryBot.create(:user)
      expect(location.editor?(visitor)).to be false
    end

    it "returns false when no user is signed in" do
      expect(location.editor?(nil)).to be false
    end
  end

  describe "#pretty_path" do
    it "includes the location name parameterized" do
      location = FactoryBot.create(:location)
      expect(location.pretty_path).to include(location.id.to_s)
      expect(location.pretty_path).to include(location.name.parameterize)
    end

    it "doesn't freak out if the name is nil" do
      location = FactoryBot.create(:location)
      location.name = nil
      expect(location.pretty_path).to include(location.id.to_s)
    end

    it "is empty if the location isn't persisted" do
      location = Location.new
      expect(location.pretty_path).to be_nil
    end
  end

  describe "#image and #has_image?" do
    let(:location) { FactoryBot.create(:location) }

    context 'no item' do
      it 'return nothing' do
        expect(location.image).to be_nil
        expect(location).not_to be_has_image
      end
    end

    context 'has items' do
      let!(:item_1) { FactoryBot.create(:item, location: location) }
      let!(:item_2) { FactoryBot.create(:item, :with_image, location: location) }

      it "get image of one of items" do
        expect(location.image.attachment).to eq item_2.image.attachment
        expect(location).to be_has_image
      end
    end
  end

  describe '.for_nearests' do
    let!(:location_1) { FactoryBot.create(:location, name: 'cake of Ba Ngoai') }
    let!(:location_2) { FactoryBot.create(:location, name: 'noodles', description: 'noodles and cake of 4P') }
    let!(:location_3) { FactoryBot.create(:location, name: 'pizza 4P') }
    let!(:location_4) { FactoryBot.create(:location, name: 'cake of Ba Noi') }
    let(:latitude) { -6.2189898 }
    let(:longitude) {106.7861758 }

    before do
      Location.update(latitude: latitude, longitude: longitude)
      location_4.update(latitude: 0, longitude: 0)
    end

    context 'no text' do
      it 'returns nearest locations within distance 50' do
        expect(Location.for_nearests([latitude, longitude])).to match_array [location_1, location_2, location_3]
      end
    end

    context 'has text' do
      it 'returns nearest locations within distance 50 with matched text' do
        expect(Location.for_nearests([latitude, longitude], text: 'cake')).to match_array [location_1, location_2]
      end
    end
  end
end
