require File.dirname(__FILE__) + '/spec_helper'
describe "Tag View Helpers" do
  include Merb::GlobalHelpers

  describe "cdata_section" do
    it "should wrap a cdata section" do
      cdata_section("<hello world>").should == "<![CDATA[<hello world>]]>"
    end
  end

  describe "escape_once" do
    it "should html escape a string without double escaping" do
      escape_once('1 < 2 &amp; 3').should == "1 &lt; 2 &amp; 3"
      escape_once(escape_once('1 < 2 &amp; 3')).should == "1 &lt; 2 &amp; 3"
    end
  end

  describe "tag_options" do
    it "should convert hash to html tag options" do
      str = tag_options("class" => "show", :class => "elsewhere")
      str.should match(/class="show"/)
      str.should match(/class="elsewhere"/)
    end
  
    it "should reject nil options" do
      tag_options(:ignored => nil).should == ""
    end
  
    it "should accept false option" do
      tag_options(:value => false).should == %{value="false"}
    end
  
    it "should accept blank option" do
      tag_options(:included => "").should == %{included=""}
    end
  
    it "should convert boolean option" do
      str = tag_options(:disabled => true, :multiple => true, :readonly => true)
      str.should match(/disabled="true"/)
      str.should match(/multiple="true"/)
      str.should match(/readonly="true"/)
    end
  end

  # TODO (port rails specs for content_tag)
  # describe "content_tag" do
  #   include MerbWheels::Helpers::TagHelpers
  #   
  #   
  # end
  # 
end