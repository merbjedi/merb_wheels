require File.dirname(__FILE__) + '/../spec_helper'

describe "excerpt" do
  include Merb::GlobalHelpers

  it "should quote the surrounding text of a matching string" do
    excerpt("This is a beautiful morning", "beautiful", 5).should == \
            "...is a beautiful morn..."
    
    excerpt("This is a beautiful morning", "this", 5).should == \
            "This is a..."
    
    excerpt("This is a beautiful morning", "morning", 5).should == \
            "...iful morning"
    
    excerpt("This is a beautiful morning", "day").should == nil
  end
  
  it "should handle border cases" do
    excerpt("", "", 0).should == ""

    excerpt("a", "a", 0).should == "a"
    excerpt("abc", "b", 0).should == "...b..."
    excerpt("abc", "b", 1).should == "abc"
    excerpt("abcd", "b", 1).should == "abc..."
    excerpt("zabc", "b", 1).should == "...abc"
    excerpt("zabcd", "b", 1).should == "...abc..."
    excerpt("zabcd", "b", 2).should == "zabcd"
    
    excerpt("  zabcd  ", "b", 4).should == "zabcd"
    excerpt("z  abc  d", "b", 1).should == "...abc..."
  end
  
  it "should play nice with regex" do
    excerpt('This is a beautiful! morning', 'beautiful', 5).should == '...is a beautiful! mor...'
    excerpt('This is a beautiful? morning', 'beautiful', 5).should == '...is a beautiful? mor...'
  end
  
  it "should allow an options hash config" do
    excerpt("This is a beautiful morning", "beautiful", :radius => 5).should == "...is a beautiful morn..."
    excerpt("This is a beautiful morning", "beautiful", :omission => "[...]",:radius => 5).should == \
            "[...]is a beautiful morn[...]"

    # test a large excerpt text 
    orig =   "This is the ultimate supercalifragilisticexpialidoceous very looooooooooooooooooong looooooooooooong beautiful morning with amazing sunshine and awesome temperatures. So what are you gonna do about it?"
    result = "This is the ultimate supercalifragilisticexpialidoceous very looooooooooooooooooong looooooooooooong beautiful morning with amazing sunshine and awesome tempera[...]"    
    excerpt(orig, "very", :omission => "[...]").should == result
  end
end