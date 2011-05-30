require 'spec_helper'

describe ViewTemplate do
  # FIELDS = [:name, :prefix, :partial, :source, :locale, :formats,
  #           :handlers, :versions, :created_at, :updated_at]

  it { should have_fields(:name, :prefix, :source) }
  it { should have_field(:partial).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:formats).with_default_value_of("html") }
  it { should have_field(:locale).with_default_value_of("en") }
  it { should have_field(:handlers).with_default_value_of("haml") }
  it { should have_field(:status).with_default_value_of("production") }

  [:name, :prefix, :source].each do |field|
    it { should validate_presence_of(field) }
  end

  [Mongoid::Versioning, Mongoid::Timestamps].each do |mod|
    it { subject.class.included_modules.should include(mod) }
  end

  it "only saves up to 3 versions" do
    template = Factory(:view_template)
    (1..4).each { |i| template.update_attribute(:source, i.to_s) }
    template.versions.size.should == 3
  end

  it "clears the MongoidResolver instance cache after saving" do
    MongoidResolver.instance.should_receive(:clear_cache)
    subject.save(:validate => false)
  end

  context "duplicate validation" do
    before do
      @existing = Factory(:view_template, :status => "production")
      @template = Factory.build(:duplicate_view_template, :status => "production")
    end

    it "adds error message to :name if name/prefix is a duplicate production" do
      @template.valid?
      @template.errors[:name].should == [I18n.t('mongoid.errors.messages.duplicate')]
    end

    it "allows duplicate templates if they are in development " do
      @template.status = "development"
      @template.valid?
      @template.errors[:name].should == []
    end
  end

  context "Haml validation" do
    before { @template = Factory.build(:invalid_haml_view_template) }

    it "gives a :source error if invalid Haml is present" do
      Haml::Engine.any_instance.stub(:render) { raise "any instance!" }
      @template.valid?
      @template.errors[:source].first.should match /#{I18n.t('mongoid.errors.messages.haml', :exception => 'any instance!')}/
    end

    it "allows 'no block given' exceptions" do
      Haml::Engine.any_instance.stub(:render) { raise LocalJumpError }
      @template.source = "=yield"
      @template.should be_valid
    end

    it "doesn't validate if handlers isn't 'haml' " do
      @template.handlers = 'erb'
      @template.should be_valid
    end
  end

  describe "#revert" do
    before do
      @template = Factory(:view_template)
      (1..3).each { |i| @template.update_attribute(:source, i.to_s)  }
      @reversion = @template.revert("2")
    end

    it "returns nil if not provided a version number" do
      @template.revert(nil).should be_nil
    end

    it "makes the reverted vesion the most current" do
      @template.reload.source.should == @reversion.source
      @template.version.should == 5
    end

    it "removes the reverted version from the versions history" do
      @template.reload.versions.to_a.should_not include(@reversion)
    end
  end

  describe "#successful_update?" do
    before { @template = Factory.build(:view_template) }

    it "result is based on :revert param first" do
      @template.should_receive(:revert).with("foo") { true }
      @template.successful_update?(:revert => "foo").should be_true
    end

    it "result is based on :view_template param if :revert is nil" do
      @template.stub(:revert){ nil }
      @template.should_receive(:update_attributes).with("123") { true }
      @template.successful_update?(:revert => "foo",
                                   :view_template => '123').should be_true
    end
  end

  describe ".preview" do
    def path_for(template)
      "#{template.prefix}/#{template.name}"
    end

    shared_examples_for "a full preview" do
      it "calls render on the view with the specified layout and template" do
        @mock_view.should_receive(:render).with(
          { :template => path_for(@template), :layout => path_for(@layout) }
        )
        ViewTemplate.preview(@target.id)
      end
    end

    shared_examples_for "a layout preview" do
      context "and a template is present" do
        before { @template = Factory(:home_page_view_template) }
        it_behaves_like "a full preview"
      end

      context "and a template isn't present" do
        it "calls render on the view with just the layout" do
          @mock_view.should_receive(:render).with(
            { :template => path_for(@layout) }
          )
          ViewTemplate.preview(@layout.id)
        end
      end
    end

    before do
      @mock_view = double(ActionView::Base)
      ActionView::Base.stub(:new).with('resolver', {}) { @mock_view }
    end

    context "when previewing a template" do
      before do
        @template = Factory(:home_page_view_template)
        PreviewResolver.stub(:for_document).with(@template) { 'resolver' }
        @target = @template
      end

      context "and a layout is present" do
        before { @layout = Factory(:pages_layout) }

        it_behaves_like "a full preview"
      end

      context "and an application layout is present" do
        before { @layout = Factory(:pages_layout, :name => 'application') }

        it_behaves_like "a full preview"
      end

      context "and a layout isn't present" do
        it "calls render on the view with just the template" do
          @mock_view.should_receive(:render).with(
            { :template => path_for(@template) }
          )
          ViewTemplate.preview(@template.id)
        end
      end
    end

    context "when previewing a layout" do
      before do
        @layout = Factory(:pages_layout)
        PreviewResolver.stub(:for_document).with(@layout) { 'resolver' }
        @target = @layout
      end

      it_behaves_like "a layout preview"
    end

    context "when previewing an application layout" do
      before do
        @layout = Factory(:pages_layout, :name => 'application')
        PreviewResolver.stub(:for_document).with(@layout) { 'resolver' }
        @target = @layout
      end

      it_behaves_like "a layout preview"
    end
  end
end
