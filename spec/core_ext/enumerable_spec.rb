require File.dirname(__FILE__) + '/../spec_helper'

describe Enumerable do
  
  Payment = Struct.new(:price)
  class SummablePayment < Payment
    def +(p) self.class.new(price + p.price) end
  end
  
  describe "#group_by" do
    it "should group a list by a calculated value" do
      names = %w(marcel sam david jeremy)
      klass = Struct.new(:name)
      objects = (1..50).inject([]) do |people,|
        p = klass.new
        p.name = names.sort_by { rand }.first
        people << p
      end

      grouped = objects.group_by { |object| object.name }

      grouped.each do |name, group|
        group.all? { |person| person.name == name }.should be_true
      end

      grouped.keys.should == objects.uniq.map{|i| i.name}
      
      {}.merge(grouped).present?.should be_true
    end
  end
  
  describe "#sum" do
    it "should calculate the sum for a list of integers" do
      [5, 15, 10].sum.should == 30
      [5, 15, 10].sum { |i| i }.should == 30

      %w(a b c).sum.should == "abc"
      %w(a b c).sum { |i| i }.should == "abc"

      payments = [ Payment.new(5), Payment.new(15), Payment.new(10) ]
      payments.sum(&:price).should == 30
      payments.sum { |p| p.price * 2 }.should == 60

      payments = [ SummablePayment.new(5), SummablePayment.new(15) ]
      payments.sum.should == SummablePayment.new(20)
      payments.sum { |p| p }.should == SummablePayment.new(20)
    end
    
    it "should handle nil sums" do
      lambda {
        [5, 15, nil].sum
      }.should raise_error(TypeError) 
      
      payments = [ Payment.new(5), Payment.new(15), Payment.new(10), Payment.new(nil) ]
      
      lambda {
        payments.sum(&:price)
      }.should raise_error(TypeError)

      payments.sum { |p| p.price.to_i * 2 }.should == 60
    end
    
    it "should handle empty lists" do
      [].sum.should == 0
      [].sum { |i| i }.should == 0
      [].sum(Payment.new(0)).should == Payment.new(0)
    end
  end
  
  describe "#index_by" do
    it "should index the list into a hash by calculated value" do
      payments = [ Payment.new(5), Payment.new(15), Payment.new(10) ]
      payments.index_by { |p| p.price }.should == { 5 => payments[0], 15 => payments[1], 10 => payments[2] }
    end
  end
  
  describe "#many?" do
    it "should return true if a list has more than 1 element" do
      [].many?.should be_false
      [ 1 ].many?.should be_false
      [ 1, 2 ].many?.should be_true
    end
    
    it "should handle blocks by filtering based on the calculated bool" do
      [].many? {|x| x > 1 }.should be_false
      [ 2 ].many? {|x| x > 1 }.should be_false
      [ 1, 2 ].many? {|x| x > 1 }.should be_false
      [ 1, 2, 2 ].many? {|x| x > 1 }.should be_true
    end
  end
  
end