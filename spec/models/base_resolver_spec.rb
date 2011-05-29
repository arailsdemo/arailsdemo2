require "spec_helper"

describe BaseResolver do
  it "inherits from ActionView::Resolver" do
    subject.class.ancestors.should include ::ActionView::Resolver
  end

  describe "#find_templates" do
    def found_view_templates
      subject.find_templates(
        'posts', 'layouts', false, :handlers => [:erb, :haml],
        :formats => [:html, :json], :locale => [:en, :en]
      )
    end

    it "returns the found template in an array" do
      document = ViewTemplate.create(
        :name => "posts", :prefix => 'layouts', :source => 'source'
      )
      action_view_template = found_view_templates.first

      action_view_template.source.should == 'source'
      action_view_template.identifier.should == "view_template-#{document.id}-layouts-posts"
      action_view_template.virtual_path.should == "layouts/posts"
      action_view_template.formats.should == [:html]
      action_view_template.handler.should == ::Haml::Plugin
    end

    it "return an empty array if a document isn't found" do
      found_view_templates.should == []
    end

    it "returns an empty array if the document is in development" do
      document = ViewTemplate.create(
        :name => "posts", :prefix => 'layouts', :source => 'source',
        :status => "development"
      )

      found_view_templates.should == []
    end
  end
end
