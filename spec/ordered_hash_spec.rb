require File.dirname(__FILE__) + '/spec_helper'

describe MerbWheels::OrderedHash do
  before(:each) do
    @keys =   %w( blue   green  red    pink   orange )
    @values = %w( 000099 009900 aa0000 cc0066 cc6633 )
    @ordered_hash = MerbWheels::OrderedHash.new

    @keys.each_with_index do |key, index|
      @ordered_hash[key] = @values[index]
    end
  end
  
  it "should keep the order of the keys and value intact" do
    @ordered_hash.keys.should == @keys
    @ordered_hash.values.should == @values
  end
  
  it "should allow random access" do
    @keys.zip(@values).all? { |k, v| @ordered_hash[k] == v }.should be_true
  end
  
  it "should allow random assignment" do
    key, value = 'purple', '5422a8'

    @ordered_hash[key] = value
    @ordered_hash.length.should == @keys.length + 1
    @ordered_hash.keys.last.should == key
    @ordered_hash.values.last.should == value
    @ordered_hash[key].should == value
  end
  
  it "should allow deletion" do
    key, value = 'white', 'ffffff'
    bad_key = 'black'

    @ordered_hash[key] = value
    @ordered_hash.length.should == @keys.length + 1

    @ordered_hash.delete(key).should == value
    @ordered_hash.length.should == @keys.length

    @ordered_hash.delete(bad_key).should be_nil
  end
  
  it "should check keys" do
    @ordered_hash.has_key?('blue').should be_true
    @ordered_hash.key?('blue').should be_true
    @ordered_hash.include?('blue').should be_true
    @ordered_hash.member?('blue').should be_true

    @ordered_hash.has_key?('indigo').should be_false
    @ordered_hash.key?('indigo').should be_false
    @ordered_hash.include?('indigo').should be_false
    @ordered_hash.member?('indigo').should be_false
  end
  
  it "should check values" do
    @ordered_hash.has_value?('000099').should be_true
    @ordered_hash.value?('000099').should be_true
    
    @ordered_hash.has_value?('ABCABC').should be_false
    @ordered_hash.value?('ABCABC').should be_false
  end  
end

