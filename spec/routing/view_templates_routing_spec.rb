require "spec_helper"

describe ViewTemplatesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/view_templates" }.should route_to(:controller => "view_templates", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/view_templates/new" }.should route_to(:controller => "view_templates", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/view_templates/1" }.should route_to(:controller => "view_templates", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/view_templates/1/edit" }.should route_to(:controller => "view_templates", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/view_templates" }.should route_to(:controller => "view_templates", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/view_templates/1" }.should route_to(:controller => "view_templates", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/view_templates/1" }.should route_to(:controller => "view_templates", :action => "destroy", :id => "1")
    end

  end
end
