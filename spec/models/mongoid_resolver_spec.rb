require "spec_helper"
describe MongoidResolver do
  let(:klass) { MongoidResolver }

  it "inherits from ActionView::Resolver" do
    klass.ancestors.should include ::ActionView::Resolver
  end

  it "is a singleton class" do
    expect { subject }.to raise_error NoMethodError
    klass.should respond_to :instance
  end

  describe "#find_templates" do
    it "returns the found template in an array" do
      document = ViewTemplate.create(
        :name => "posts", :prefix => 'layouts', :source => 'source'
      )

      action_view_template = klass.instance.find_templates(
        'posts', 'layouts', false,
        :handlers => [:erb, :haml],
        :formats => [:html, :json],
        :locale => [:en, :en]
      ).first

      action_view_template.source.should == 'source'
      action_view_template.identifier.should == "view_template-#{document.id}-layouts-posts"
      action_view_template.virtual_path.should == "layouts/posts"
      action_view_template.formats.should == [:html]
      action_view_template.handler.should == ::Haml::Plugin
    end

    it "return an empty array if a document isn't found" do
      klass.instance.find_templates('foo', 'bar', false, {} ).should == []
    end
  end
end
