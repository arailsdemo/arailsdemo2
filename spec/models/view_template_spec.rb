require 'spec_helper'

describe ViewTemplate do
  # FIELDS = [:name, :prefix, :partial, :source, :locale, :formats, :handlers]

  it { should have_fields(:name, :prefix, :source) }
  it { should have_field(:partial).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:formats).with_default_value_of(:html) }
  it { should have_field(:locale).with_default_value_of(:en) }
  it { should have_field(:handlers).with_default_value_of(:haml) }

  [:name, :prefix, :source].each do |field|
    it { should validate_presence_of(field) }
  end
end
