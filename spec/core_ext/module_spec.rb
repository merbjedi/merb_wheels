require File.dirname(__FILE__) + '/../spec_helper'

describe Module do
  describe "#mattr_accessor" do
    before do
      m = @module = Module.new do
        mattr_accessor :foo
        mattr_accessor :bar, :instance_writer => false
      end
      @class = Class.new
      @class.instance_eval { include m }
      @object = @class.new
    end
    
    it "should use mattr default value" do
      @module.foo.should == nil
      @object.foo.should == nil
    end
    
    it "should set mattr value" do
      @module.foo = :test
      @object.foo.should == :test

      @object.foo = :test2
      @module.foo.should == :test2
    end
    
    it "should not create instance writer" do
      @module.respond_to?(:foo).should be_true
      @module.respond_to?(:foo=).should be_true
      @object.respond_to?(:bar).should be_true
      @object.respond_to?(:bar=).should be_false
    end
  end
end
