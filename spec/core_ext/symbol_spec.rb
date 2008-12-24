require File.dirname(__FILE__) + '/../spec_helper'

describe Symbol do
  describe "#to_proc" do
    it "should convert symbols to procs for some whacky enumerable access" do
      [:one, :two, :three].map(&:to_s).should == %w(one two three)
      {1 => "one", 2 => "two", 3 => "three"}.sort_by(&:first).map(&:last).should == %w(one two three)
    end
  end
end