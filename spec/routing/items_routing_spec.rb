require "rails_helper"

describe ItemsController, type: :routing do

  describe "routing" do
    it "routes to #new" do
      expect(:get => "/locations/123/items/new").to route_to("items#new", location_id: "123")
    end

    it "routes to #show" do
      expect(:get => "/locations/123/items/456").to route_to("items#show", location_id: "123", id: "456")
    end

    it "routes to #edit" do
      expect(:get => "/locations/123/items/456/edit").to route_to("items#edit", location_id: "123", id: "456")
    end

    it "routes to #create" do
      expect(:post => "/locations/123/items").to route_to("items#create", location_id: "123")
    end

    it "routes to #update via PUT" do
      expect(:put => "/locations/123/items/456").to route_to("items#update", location_id: "123", id: "456")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/locations/123/items/456").to route_to("items#update", location_id: "123", id: "456")
    end

    it "routes to #destroy" do
      expect(:delete => "/locations/123/items/456").to route_to("items#destroy", location_id: "123", id: "456")
    end
  end

end

