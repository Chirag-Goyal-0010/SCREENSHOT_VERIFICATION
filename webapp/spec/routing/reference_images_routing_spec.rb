require "rails_helper"

RSpec.describe ReferenceImagesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/reference_images").to route_to("reference_images#index")
    end

    it "routes to #new" do
      expect(get: "/reference_images/new").to route_to("reference_images#new")
    end

    it "routes to #show" do
      expect(get: "/reference_images/1").to route_to("reference_images#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/reference_images/1/edit").to route_to("reference_images#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/reference_images").to route_to("reference_images#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/reference_images/1").to route_to("reference_images#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/reference_images/1").to route_to("reference_images#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/reference_images/1").to route_to("reference_images#destroy", id: "1")
    end
  end
end
