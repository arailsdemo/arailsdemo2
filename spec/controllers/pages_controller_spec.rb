require 'spec_helper'

describe PagesController do
  describe "GET 'home'" do
    it "calls #find_all on the MongoidResolver instance" do
      MongoidResolver.instance.should_receive(:find_all).
                               at_least(1).times { [] }
      get 'home'
    end
  end
end
