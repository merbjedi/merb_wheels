require File.dirname(__FILE__) + '/../spec_helper'

describe String do
  
  describe "inflections" do
    before do
      @inflections = YAML.load File.read(File.dirname(__FILE__) / ".." / "fixture" / "inflections.yml")
    end
    
    it "should pluralize strings" do
      @inflections["singular_to_plural"].each do |singular, plural|
        singular.pluralize.should == plural
      end
      "plurals".pluralize.should == "plurals"
    end
    
    it "should singularize strings" do
      @inflections["singular_to_plural"].each do |singular, plural|
        plural.singularize.should == singular
      end
    end
    
    it "should titleize strings" do
      @inflections["mixture_to_title_case"].each do |pretitleized, titleized|
        pretitleized.titleize.should == titleized
      end
    end
    
    it "should camelize strings" do
      @inflections["camel_to_underscore"].each do |camel, underscore|
        underscore.camelize.should == camel
      end
    end
    
    it "should camelize strings with lower case option" do
      'Capital'.camelize(:lower).should == "capital"
    end
    
    it "should underscore strings" do
      @inflections["camel_to_underscore"].each do |camel, underscore|
        camel.underscore.should == underscore
      end

      "HTMLTidy".underscore.should == "html_tidy"
      "HTMLTidyGenerator".underscore.should == "html_tidy_generator"
    end
    
    it "should convert underscore to lower camel" do
      @inflections["underscore_to_lower_camel"].each do |underscored, lower_camel|
        underscored.camelize(:lower).should == lower_camel
      end
    end
    
    it "should demodulize strings" do
      "MyApplication::Billing::Account".demodulize.should == "Account"
    end
    
    it "should convert class names to foreign keys" do
      @inflections["class_name_to_foreign_key_with_underscore"].each do |klass, foreign_key|
        klass.foreign_key.should == foreign_key
      end

      @inflections["class_name_to_foreign_key_without_underscore"].each do |klass, foreign_key|
        klass.foreign_key(false).should == foreign_key
      end
    end
    
    it "should tableize strings" do
      @inflections["class_name_to_table_name"].each do |class_name, table_name|
        class_name.tableize.should == table_name
      end
    end
    
    it "should classify strings" do
      @inflections["class_name_to_table_name"].each do |class_name, table_name|
        table_name.classify.should == class_name
      end
    end
    
    it "should humanize strings" do
      @inflections["underscore_to_human"].each do |underscore, human|
        underscore.humanize.should == human
      end
    end
  end
  
  describe "#ord" do
    it "should find ord" do
      'a'.ord.should == 97
      'abc'.ord.should == 97
    end
  end
  
  describe "access methods" do
    it "should provie at, from, first, and last" do
      s = "hello"
      s.at(0).should == "h"

      s.from(2).should == "llo"
      s.to(2).should == "hel"

      s.first.should == "h"
      s.first(2).should == "he"

      s.last.should == "o"
      s.last(3).should == "llo"
      s.last(10).should == "hello"

      'x'.first.should == "x"
      'x'.first(4).should == "x"

      'x'.last.should == "x"
      'x'.last(4).should == "x"
    end
    
    it "should return real strings from access" do
      hash = {}
      hash["h"] = true
      hash["hello123".at(0)] = true
      hash.keys.should == %w(h)

      hash = {}
      hash["llo"] = true
      hash["hello".from(2)] = true
      hash.keys.should == %w(llo)

      hash = {}
      hash["hel"] = true
      hash["hello".to(2)] = true
      hash.keys.should == %w(hel)

      hash = {}
      hash["hello"] = true
      hash["123hello".last(5)] = true
      hash.keys.should == %w(hello)

      hash = {}
      hash["hello"] = true
      hash["hello123".first(5)] = true
      hash.keys.should == %w(hello)
    end
  end
  
  
  describe "starts and ends with methods" do
    it "should provide starts_wth?, ends_with?, start_with? and end_with?" do
      s = "hello"
      s.starts_with?('h').should be_true
      s.starts_with?('hel').should be_true
      s.starts_with?('el').should be_false

      s.start_with?('h').should be_true
      s.start_with?('hel').should be_true
      s.start_with?('el').should be_false
      
      s.ends_with?('o').should be_true
      s.ends_with?('lo').should be_true
      s.ends_with?('el').should be_false
      
      s.end_with?('o').should be_true
      s.end_with?('lo').should be_true
      s.end_with?('el').should be_false
    end
  end
  
  describe "#squish" do
    it "should remove consecutive whitespace on a string" do
      original = %{ A string with tabs(\t\t), newlines(\n\n), and
                    many spaces(  ). }

      expected = "A string with tabs( ), newlines( ), and many spaces( )."

      # Make sure squish returns what we expect:
      original.squish.should == expected
      
      # But doesn't modify the original string:
      original.should_not == expected

      # Make sure squish! returns what we expect:
      original.squish!.should == expected
      
      # And changes the original string:
      original.should == expected
    end
  end
  
end
