require 'rails_helper'

describe Item do
  include Rails.application.routes.url_helpers

  describe "#to_param" do
    it "includes the item name parameterized" do
      item = FactoryBot.create(:item)
      expect(item.to_param).to include(item.id.to_s)
      expect(item.to_param).to include(item.name.parameterize)
    end

    it "doesn't freak out if the name is nil" do
      item = Item.new
      expect(item.to_param).to include(item.id.to_s)
    end
  end

end
