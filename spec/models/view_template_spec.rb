require 'spec_helper'

describe ViewTemplate do
  # FIELDS = [:name, :prefix, :partial, :source, :locale, :formats, :handlers]

  it { should have_fields(:name, :prefix, :source) }
  it { should have_field(:partial).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:formats).with_default_value_of("html") }
  it { should have_field(:locale).with_default_value_of("en") }
  it { should have_field(:handlers).with_default_value_of("haml") }

  [:name, :prefix, :source].each do |field|
    it { should validate_presence_of(field) }
  end

  it { should validate_uniqueness_of(:name).scoped_to(:prefix) }

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
end
