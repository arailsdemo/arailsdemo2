require "spec_helper"

describe PreviewResolver do
  let(:layout) { @layout ||= Factory(:pages_layout) }

  before { @document = Factory(:home_page_view_template) }

  describe ".for_document" do
    it "sets the document of interest for the resolver" do
      resolver = PreviewResolver.for_document(@document)
      resolver.target.should == @document
    end
  end

  describe "find_templates" do
    context "when the resolver instance has an existing document" do
      before { @resolver = PreviewResolver.for_document(@document) }

      it "uses that document if queried for it" do
        @resolver.find_templates(
          @document.name, @document.prefix, @document.partial,
          :handlers => [:erb, :haml],
          :formats => [:html, :json],
          :locale => [:en, :en]
        ).first.identifier.should ==
          "view_template-#{@document.id}-#{@document.prefix}-#{@document.name}"
      end

      it "will search for another document if the existing document is not being searched for" do
        @resolver.find_templates(
          layout.name, layout.prefix, layout.partial,
          :handlers => [:erb, :haml],
          :formats => [:html, :json],
          :locale => [:en, :en]
        ).first.identifier.should ==
          "view_template-#{layout.id}-#{layout.prefix}-#{layout.name}"
      end
    end
  end
end
