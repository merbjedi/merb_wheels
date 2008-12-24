require File.dirname(__FILE__) + '/spec_helper'

describe "Sanitize View Helpers" do
  include Merb::GlobalHelpers

  describe "strip_links" do
    it "should strip html anchor tags out from a string" do
      strip_links("Dont touch me").should == "Dont touch me"
      strip_links("<a<a").should == "<a<a"
      strip_links("<a href='almost'>on my mind</a>\n<A href='almost'>all day long</A>").should == "on my mind\nall day long"
      strip_links("<a href='http://www.rubyonrails.com/'><a href='http://www.rubyonrails.com/' onlclick='steal()'>0wn3d</a></a>").should == "0wn3d"
      strip_links("<a href='http://www.rubyonrails.com/'>Mag<a href='http://www.ruby-lang.org/'>ic").should == "Magic"
      strip_links("<href onlclick='steal()'>FrrFox</a></href>").should == "FrrFox"
      strip_links("<a href='almost'>My mind</a>\n<A href='almost'>all <b>day</b> long</A>").should == "My mind\nall <b>day</b> long"
      strip_links("<<a>a href='hello'>all <b>day</b> long<</A>/a>").should == "all <b>day</b> long"
    end
  end

  describe "sanitize" do
    it "should sanitize a form" do
      sanitize(%{<form action="/foo/bar" method="post"><input></form>}).should == ""
    end
  end

  describe "sanitize_css" do
    it "should sanitize a bit of css" do
      raw      = %(display:block; position:absolute; left:0; top:0; width:100%; height:100%; z-index:1; background-color:black; background-image:url(http://www.ragingplatypus.com/i/cam-full.jpg); background-x:center; background-y:center; background-repeat:repeat;)
      expected = %(display: block; width: 100%; height: 100%; background-color: black; background-image: ; background-x: center; background-y: center;)
      sanitize_css(raw).should == expected
    end
  end

  describe "strip_tags" do
    it "should remove the tags from a block" do
      strip_tags("<<<bad html").should == "<<<bad html"
      strip_tags("<<<bad html>").should == "<<"
      strip_tags("Dont touch me").should == "Dont touch me"
      strip_tags("<p>This <u>is<u> a <a href='test.html'><strong>test</strong></a>.</p>").should == "This is a test."
      strip_tags("Wei<<a>a onclick='alert(document.cookie);'</a>/>rdos").should == "Weirdos"
      strip_tags("This is a test.").should == "This is a test."
    
      html = %{<title>This is <b>a <a href="" target="_blank">test</a></b>.</title>\n\n<!-- it has a comment -->\n\n<p>It no <b>longer <strong>contains <em>any <strike>HTML</strike></em>.</strong></b></p>\n}
      html_stripped = %{This is a test.\n\n\nIt no longer contains any HTML.\n}
      strip_tags(html).should == html_stripped
      strip_tags("This has a <!-- comment --> here.").should == "This has a  here."
      [nil, '', '   '].each { |blank| strip_tags(blank).should == blank }
    end
  end
end