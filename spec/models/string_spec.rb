require 'spec_helper'

describe String do
  describe "#shorten" do
    it "should do nothing if the string is less than the given length" do
      "nicebar".shorten(12).should == "nicebar"
    end
    it "should shorten it otherwise" do
      "nicebar".shorten(6).should == "nic..."
    end
  end
end

