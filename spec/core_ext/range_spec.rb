require File.dirname(__FILE__) + '/../spec_helper'

describe Range do
  
  describe "#overlaps?" do
    it "should check overlaps for last inclusive" do
      (1..5).overlaps?(5..10).should be_true
    end
    
    it "should check overlaps for last exclusive" do
      (1...5).overlaps?(5..10).should be_false
    end
    
    it "should check overlaps for first inclusive" do
      (5..10).overlaps?(1..5).should be_true
    end

    it "should check overlaps for first exclusive" do
      (5..10).overlaps?(1...5).should be_false
    end
  end
  
  describe "#include_with_range?" do
    it "should check include for identical inclusive" do
      (1..10).include_with_range?(1..10).should be_true
    end

    it "should check include other for exclusive end" do
      (1..10).include_with_range?(1...10).should be_true
    end

    it "should check for exclusive end that should not include identical with inclusive end" do
      (1...10).include_with_range?(1..10).should be_false
    end
    
    it "should not include overlapping first" do
      (2..8).include_with_range?(1..3).should be_false
    end
    
    it "should not include overlapping last" do
      (2..8).include?(5..9).should be_false
    end
  end
  
end
