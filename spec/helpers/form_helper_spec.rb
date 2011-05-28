require "spec_helper"

describe FormHelper do
  describe "#select_options_from_t" do
    it "returns select options based off of a given translation target" do
      I18n.stub(:t).with('foo').and_return( { "v" => "V", "a" => "A" } )

      helper.select_options_from_t('foo').should == [["A", "a"], ["V", "v"]]
    end
  end
end