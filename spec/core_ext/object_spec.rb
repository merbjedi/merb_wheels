require File.dirname(__FILE__) + '/../spec_helper'

describe Object do
  describe "#try" do
    before(:each) do
      @string = "Hello"
    end
    
    it "should return nil when calling a nonexistent method" do
      method = :undefined_method
      @string.respond_to?(method).should == false
      @string.try(method).should == nil
    end
    
    it "should send the correct method call if exists" do
      @string.try(:size).should == 5
    end
    
    it "should not allow access to private methods" do
      class << @string
        private :size
      end

      @string.try(:size).should == nil
    end
  end
  
  describe "#try with arguments" do
    attr_reader :klass, :object
    before(:each) do
      @klass = Class.new do
        def foo(arg=nil)
          block_given? ? yield : (arg || :bar)
        end
      end

      @object = klass.new
    end
    
    it "should send when object responds to message" do
      object.try(:foo).should == :bar
    end
    
    it "should return nil when object doesn't respond to message" do
      object.try(:fizz).should be_nil
    end
    
    it "should allow args" do
      object.try(:foo, :wee).should == :wee
    end
    
    it "should allow block" do
      object.try(:foo) { :wee }.should == :wee
    end
  end
  
  describe "#present?" do
    class EmptyTrue
      def empty?() true; end
    end

    class EmptyFalse
      def empty?() false; end
    end
    
    BLANK = [ EmptyTrue.new, nil, false, '', '   ', "  \n\t  \r ", [], {} ]
    NOT   = [ EmptyFalse.new, Object.new, true, 0, 1, 'a', [nil], { nil => 0 } ]

    it "should return true if not blank" do
      BLANK.each { |v| v.present?.should be_false}
      NOT.each   { |v| v.present?.should be_true }
    end
  end
end