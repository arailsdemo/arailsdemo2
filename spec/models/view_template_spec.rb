require 'spec_helper'

describe ViewTemplate do
  # FIELDS = [:name, :prefix, :partial, :source, :locale, :formats,
  #           :handlers, :versions, :created_at, :updated_at]

  it { should have_fields(:name, :prefix, :source) }
  it { should have_field(:partial).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:formats).with_default_value_of("html") }
  it { should have_field(:locale).with_default_value_of("en") }
  it { should have_field(:handlers).with_default_value_of("haml") }

  [:name, :prefix, :source].each do |field|
    it { should validate_presence_of(field) }
  end

  it { should validate_uniqueness_of(:name).scoped_to(:prefix) }

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
      @existing = Factory(:view_template)
      @template = Factory.build(:duplicate_view_template)
      @template.valid?
    end

    it "removes whitespace from the name and prefix" do
      @template.name.should == @existing.name
      @template.prefix.should == @existing.prefix
    end

    it "adds error message to :name if name/prefix is a duplicate" do
      @template.errors[:name].should == [I18n.t('mongoid.errors.messages.duplicate')]
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
end
