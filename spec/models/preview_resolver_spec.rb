require "spec_helper"

describe PreviewResolver do
  before { @document = Factory(:home_page_view_template) }

  describe ".for_document" do
    it "sets the document of interest for the resolver" do
      resolver = PreviewResolver.for_document(@document)
      resolver.target.should == @document
    end
  end

  describe "find_templates" do
    def document_should_be_found(document)
      @resolver.find_templates(
        document.name, document.prefix, document.partial,
        :handlers => [:erb, :haml],
        :formats => [:html, :json],
        :locale => [:en, :en]
      ).first.identifier.should ==
        "view_template-#{document.id}-#{document.prefix}-#{document.name}"
    end

    context "when the resolver instance has an existing document" do
      before { @resolver = PreviewResolver.for_document(@document) }

      it "uses that document if queried for it" do
        document_should_be_found(@document)
      end

      context "and the existing document isn't being searched for" do
        it "will search for a production document over a development document" do
          Factory(:pages_layout, :status => 'development')
          layout = Factory(:pages_layout, :status => 'production')
          document_should_be_found(layout)
        end

        it "will search for a development document if a production document is not present" do
          layout = Factory(:pages_layout, :status => 'development')
          document_should_be_found(layout)
        end
      end
    end
  end
end
