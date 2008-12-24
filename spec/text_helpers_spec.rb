require File.dirname(__FILE__) + '/spec_helper'

describe "Text View Helpers" do
  include Merb::GlobalHelpers

  describe "truncate" do  
    it "should truncate a string of defined length" do
      truncate("Hello World!", :length => 12).should == "Hello World!"
      truncate("Hello World!!", :length => 12).should == "Hello Wor..."
    end
  
    it "should default to truncating a length of 30" do
      str = "This is a string that will go longer then the default truncate length of 30"
      truncate(str).should == "#{str[0...27]}..."
    end
  
    it "should take an options hash for configuration" do
      truncate("This is a string that will go longer then the default truncate length of 30", :omission => "[...]").should == \
               "This is a string that wil[...]"
             
      truncate("Hello World!", :length => 10).should == "Hello W..."
      truncate("Hello World!", :omission => "[...]", :length => 10).should == "Hello[...]"    
    end
  
    it "should allow calling without an options hash for backwards compatibility" do
      truncate("This is a string that will go longer then the default truncate length of 30", 30, "[...]").should == \
               "This is a string that wil[...]"
             
      truncate("Hello World!", 10).should == "Hello W..."
      truncate("Hello World!", 10, "[...]").should == "Hello[...]"
    end
  end

  describe "simple_format" do
    it "should format a basic block" do
      simple_format(nil).should == "<p></p>"
      simple_format("crazy\r\n cross\r platform linebreaks").should == "<p>crazy\n<br /> cross\n<br /> platform linebreaks</p>"
      simple_format("A paragraph\n\nand another one!").should == "<p>A paragraph</p>\n\n<p>and another one!</p>"
      simple_format("A paragraph\n With a newline").should == "<p>A paragraph\n<br /> With a newline</p>"
    
      text = "A\nB\nC\nD".freeze
      simple_format(text).should == "<p>A\n<br />B\n<br />C\n<br />D</p>"

      text = "A\r\n  \nB\n\n\r\n\t\nC\nD".freeze
      simple_format(text).should == "<p>A\n<br />  \n<br />B</p>\n\n<p>\t\n<br />C\n<br />D</p>"
    
      simple_format("This is a classy test", :class => 'test').should == %q(<p class="test">This is a classy test</p>)
      simple_format("para 1\n\npara 2", :class => 'test').should == %Q(<p class="test">para 1</p>\n\n<p class="test">para 2</p>)
    end
  end

  describe "highlighter" do
    it "should highlight single matching strings" do
      highlight("This is a beautiful morning", "beautiful").should == \
                "This is a <strong class=\"highlight\">beautiful</strong> morning"
    
      highlight("This is a beautiful morning, but also a beautiful day", "beautiful").should == \
                "This is a <strong class=\"highlight\">beautiful</strong> morning, but also a <strong class=\"highlight\">beautiful</strong> day"
  
      highlight("This is a beautiful morning, but also a beautiful day", "beautiful", '<b>\1</b>').should == \
                "This is a <b>beautiful</b> morning, but also a <b>beautiful</b> day"
  
      highlight("This text is not changed because we supplied an empty phrase", nil).should == \
                "This text is not changed because we supplied an empty phrase"
    
      highlight('   ', 'blank text is returned verbatim').should == '   '

    end
  
    it "should play nice with regex chars" do
      highlight("This is a beautiful! morning", "beautiful!").should == \
                "This is a <strong class=\"highlight\">beautiful!</strong> morning"
    
      highlight("This is a beautiful! morning", "beautiful! morning").should == \
                "This is a <strong class=\"highlight\">beautiful! morning</strong>"
    
      highlight("This is a beautiful? morning", "beautiful? morning").should == \
                "This is a <strong class=\"highlight\">beautiful? morning</strong>"    
    end
  
    it "should highlight a string with multiple matches" do
      highlight('wow em', %w(wow em), '<em>\1</em>').should == %(<em>wow</em> <em>em</em>)
    end
  
    it "should allow an options hash for configuration" do
      highlight("This is a beautiful morning, but also a beautiful day", "beautiful", :highlighter => '<b>\1</b>').should == \
                "This is a <b>beautiful</b> morning, but also a <b>beautiful</b> day"
    end
  end


  describe "word_wrap" do
    it "should wrap a long string" do
      word_wrap("my very very very long string", 15).should == "my very very\nvery long\nstring"
    end
  
    it "should wrap with extra newlines" do
      word_wrap("my very very very long string\n\nwith another line", 15).should == \
                "my very very\nvery long\nstring\n\nwith another\nline"
    
    end
  
    it "should allow an options hash for configuration" do
      word_wrap("my very very very long string", :line_width => 15).should == \
                "my very very\nvery long\nstring"
    end
  end

  describe "pluralize" do
    it "should pluralize a bunch of words" do
      pluralize(1, "count").should == "1 count"
      pluralize(2, "count").should == "2 counts"
      pluralize('1', "count").should == "1 count"
      pluralize('2', "count").should == "2 counts"
      pluralize('1,066', "count").should == "1,066 counts"
      pluralize('1.25', "count").should == "1.25 counts"
      pluralize(2, "count", "counters").should == "2 counters"
      pluralize(nil, "count", "counters").should == "0 counters"
      pluralize(2, "person").should == "2 people"
      pluralize(10, "buffalo").should == "10 buffaloes"
      pluralize(1, "berry").should == "1 berry"
      pluralize(12, "berry").should == "12 berries"
    end
  end
end