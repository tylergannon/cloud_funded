require 'spec_helper'

describe Date do
  describe "#parse" do
    it "should be able to parse YYYY-mm-dd" do
      Date.parse('2012-07-28').iso8601.should == "2012-07-28"
    end

    it "should be able to parse mm/dd/yyyy" do
      lambda {
        Date.parse('07/28/2012').should == Date.parse('2012-07-28')
      }.should_not raise_error
    end
  end
end