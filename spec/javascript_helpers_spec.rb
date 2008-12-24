require File.dirname(__FILE__) + '/spec_helper'

describe "Javascript View Helpers" do
  include Merb::GlobalHelpers

  describe "escape_javascript" do
    it "should escape javascript" do
      escape_javascript(nil).should == ""
      escape_javascript(%{This "thing" is really\n netos'}).should == %{This \\"thing\\" is really\\n netos\\'}
      escape_javascript(%{backslash\\test}).should == %{backslash\\\\test}
      escape_javascript(%{dont </close> tags}).should == %{dont <\\/close> tags}
    end
  end

  describe "javascript_tag" do
    def capture(&block)
      yield
    end
  
    it "should wrap a javascript tag" do
      javascript_tag("alert('hello')").should == \
        %{<script type="text/javascript">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>}
    end
  
    it "should allow options" do
      javascript_tag("alert('hello')", :id => "the_js_tag").should == \
        "<script type=\"text/javascript\" id=\"the_js_tag\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>"
    end
  
    it "should allow a block" do
      result = javascript_tag{ "alert('hello')" }.should == \
        "<script type=\"text/javascript\">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>"
    end
  
    it "should allow a block and options hash" do
      javascript_tag(:id => "the_js_tag") { "alert('hello')" }.should == 
        %{<script type="text/javascript" id="the_js_tag">\n//<![CDATA[\nalert('hello')\n//]]>\n</script>}
    end
  
  end

  describe "javascript_cdata_section" do
    it "should wrap a string in CDATA" do
      javascript_cdata_section("alert('hello')").should == \
        %{\n//<![CDATA[\nalert('hello')\n//]]>\n}
    end
  end
end