# frozen_string_literal: true

require "rails_helper"

RSpec.describe ControlUnitsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/control_units").to route_to("control_units#index")
    end

    it "routes to #new" do
      expect(get: "/control_units/new").to route_to("control_units#new")
    end

    it "routes to #show" do
      expect(get: "/control_units/1").to route_to("control_units#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/control_units/1/edit").to route_to("control_units#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/control_units").to route_to("control_units#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/control_units/1").to route_to("control_units#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/control_units/1").to route_to("control_units#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/control_units/1").to route_to("control_units#destroy", id: "1")
    end
  end
end
