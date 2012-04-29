require "spec_helper"

describe ContrasController do
  describe "routing" do

    it "routes to #index" do
      get("/contras").should route_to("contras#index")
    end

    it "routes to #new" do
      get("/contras/new").should route_to("contras#new")
    end

    it "routes to #show" do
      get("/contras/1").should route_to("contras#show", :id => "1")
    end

    it "routes to #edit" do
      get("/contras/1/edit").should route_to("contras#edit", :id => "1")
    end

    it "routes to #create" do
      post("/contras").should route_to("contras#create")
    end

    it "routes to #update" do
      put("/contras/1").should route_to("contras#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/contras/1").should route_to("contras#destroy", :id => "1")
    end

  end
end
