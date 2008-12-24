require File.dirname(__FILE__) + '/../spec_helper'

describe Class do
  describe "#cattr_accessor" do
    before do
      @class = Class.new do
        cattr_accessor :foo
        cattr_accessor :bar, :instance_writer => false
      end
      @object = @class.new
    end
    
    it "should use cattr default value" do
      @class.foo.should == nil
      @object.foo.should == nil
    end
    
    it "should set cattr value" do
      @class.foo = :test
      @object.foo.should == :test

      @object.foo = :test2
      @class.foo.should == :test2
    end
    
    it "should not create instance writer" do
      @class.respond_to?(:foo).should be_true
      @class.respond_to?(:foo=).should be_true
      @object.respond_to?(:bar).should be_true
      @object.respond_to?(:bar=).should be_false
    end
  end
end
