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

end
