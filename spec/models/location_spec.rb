require 'rails_helper'

describe Location do

  describe ".for_display" do
    it "must have a name" do
      no_name = FactoryBot.create(:location, name: nil)
      expect(Location.for_display).to_not include(no_name)

      blank_name = FactoryBot.create(:location, name: "")
      expect(Location.for_display).to_not include(blank_name)
    end

    it "must have a description" do
      no_description = FactoryBot.create(:location, description: nil)
      expect(Location.for_display).to_not include(no_description)

      blank_description = FactoryBot.create(:location, description: "")
      expect(Location.for_display).to_not include(blank_description)
    end

    it "must have a latitude" do
      no_latitude = FactoryBot.create(:location, latitude: nil)
      expect(Location.for_display).to_not include(no_latitude)

      blank_latitude = FactoryBot.create(:location, latitude: "")
      expect(Location.for_display).to_not include(blank_latitude)
    end

    it "must have a longitude" do
      no_longitude = FactoryBot.create(:location, longitude: nil)
      expect(Location.for_display).to_not include(no_longitude)

      blank_longitude = FactoryBot.create(:location, longitude: "")
      expect(Location.for_display).to_not include(blank_longitude)
    end
  end

end
