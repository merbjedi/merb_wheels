require File.dirname(__FILE__) + '/spec_helper'

describe "Number View Helpers" do
  include Merb::GlobalHelpers

  describe "number_to_phone" do
    it "should convert a number into a formatted phone number" do
      number_to_phone(8005551212).should == "800-555-1212"
      number_to_phone(8005551212, :area_code => true).should == "(800) 555-1212"
      number_to_phone(8005551212, :delimiter => " ").should == "800 555 1212"
      number_to_phone(8005551212, :area_code => true, :extension => 123).should == "(800) 555-1212 x 123"
      number_to_phone(8005551212, :extension => "  ").should == "800-555-1212"
      number_to_phone("8005551212").should == "800-555-1212"
      number_to_phone(8005551212, :country_code => 1).should == "+1-800-555-1212"
      number_to_phone(8005551212, :country_code => 1, :delimiter => '').should == "+18005551212"
      number_to_phone(225551212).should == "22-555-1212"
      number_to_phone(225551212, :country_code => 45).should == "+45-22-555-1212"
      number_to_phone("x").should == "x"
      number_to_phone(nil).should == nil
    end 
  end 

  describe "number_to_currency" do
    it "should convert a number into a formatted currency" do
      number_to_currency(1234567890.50).should == "$1,234,567,890.50"
      number_to_currency(1234567890.506).should == "$1,234,567,890.51"
      number_to_currency(1234567891.50, :precision => 0).should == "$1,234,567,892"
      number_to_currency(1234567890.50, :precision => 1).should == "$1,234,567,890.5"
      number_to_currency(1234567890.50, :unit => "&pound;", :separator => ",", :delimiter => "").should == "&pound;1234567890,50"
      number_to_currency("1234567890.50").should == "$1,234,567,890.50"
      number_to_currency("1234567890.50", :unit => "K&#269;", :format => "%n %u").should == "1,234,567,890.50 K&#269;"
      number_to_currency("x").should == "$x"
      number_to_currency(nil).should == nil
    end
  end

  describe "number_to_percentage" do
    it "should convert a number into a formatted percentage value" do
      number_to_percentage(100).should == "100.000%"
      number_to_percentage(100, {:precision => 0}).should == "100%"
      number_to_percentage(302.0574, {:precision => 2}).should == "302.06%"
      number_to_percentage("100").should == "100.000%"
      number_to_percentage("1000").should == "1000.000%"
      number_to_percentage("x").should == "x%"
      number_to_percentage(1000, :delimiter => '.', :separator => ',').should == "1.000,000%"
      number_to_percentage(nil).should == nil
    end
  end

  describe "number_with_delimiter" do
    it "should format a number with a delimiter. e.g. 1,000,000" do
      number_with_delimiter(12345678).should == "12,345,678"
      number_with_delimiter(0).should == "0"
      number_with_delimiter(123).should == "123"
      number_with_delimiter(123456).should == "123,456"
      number_with_delimiter(123456.78).should == "123,456.78"
      number_with_delimiter(123456.789).should == "123,456.789"
      number_with_delimiter(123456.78901).should == "123,456.78901"
      number_with_delimiter(123456789.78901).should == "123,456,789.78901"
      number_with_delimiter(0.78901).should == "0.78901"
      number_with_delimiter("123456.78").should == "123,456.78"
      number_with_delimiter("x").should == "x"
      number_with_delimiter(nil).should == nil
    end
  
    it "should allow setting the delimiter via an options hash" do
      number_with_delimiter(12345678, :delimiter => ' ').should == '12 345 678'
      number_with_delimiter(12345678.05, :separator => '-').should == '12,345,678-05'
      number_with_delimiter(12345678.05, :separator => ',', :delimiter => '.').should == '12.345.678,05'
      number_with_delimiter(12345678.05, :delimiter => '.', :separator => ',').should == '12.345.678,05'
    end
  end

  describe "number_with_precision" do
    it "should format a float so that it only shows a certain number of decimal places" do
      number_with_precision(111.2346).should == "111.235"
      number_with_precision(31.825, :precision => 2).should == "31.83"
      number_with_precision(111.2346, :precision => 2).should == "111.23"
      number_with_precision(111, :precision => 2).should == "111.00"
      number_with_precision("111.2346").should == "111.235"
      number_with_precision("31.825", :precision => 2).should == "31.83"
      number_with_precision(111.50, :precision => 0).should == "112"
      number_with_precision(1234567891.50, :precision => 0).should == "1234567892"

      # Return non-numeric params unchanged.
      number_with_precision("x").should == "x"
      number_with_precision(nil).should == nil
    end
  
    it "should allow an options hash to configure delimiter and precision" do
      number_with_precision(31.825, :precision => 2, :separator => ',').should == '31,83'
      number_with_precision(1231.825, :precision => 2, :separator => ',', :delimiter => '.').should == '1.231,83'
    end
  end

  describe "number_to_human_size" do
    it "should convert a number to look like a file size" do
      number_to_human_size(0).should == '0 Bytes'
      number_to_human_size(1).should == '1 Byte'
      number_to_human_size(3.14159265).should == '3 Bytes' 
      number_to_human_size(123.0).should == '123 Bytes'
      number_to_human_size(123).should == '123 Bytes'
      number_to_human_size(1234).should == '1.2 KB'
      number_to_human_size(12345).should == '12.1 KB'
      number_to_human_size(1234567).should == '1.2 MB'
      number_to_human_size(1234567890).should == '1.1 GB'
      number_to_human_size(1234567890123).should == '1.1 TB'
      number_to_human_size(1025.terabytes).should == '1025 TB'
      number_to_human_size(444.kilobytes).should == '444 KB'
      number_to_human_size(1023.megabytes).should == '1023 MB'
      number_to_human_size(3.terabytes).should == '3 TB'
      number_to_human_size(1234567, :precision => 2).should == '1.18 MB'
      number_to_human_size(3.14159265, :precision => 4).should == '3 Bytes'
      number_to_human_size("123").should == "123 Bytes"
      number_to_human_size(1.0123.kilobytes, :precision => 2).should == '1.01 KB'
      number_to_human_size(1.0100.kilobytes, :precision => 4).should == '1.01 KB'
      number_to_human_size(10.000.kilobytes, :precision => 4).should == '10 KB'
      number_to_human_size(1.1).should == '1 Byte'
      number_to_human_size(10).should == '10 Bytes'
      number_to_human_size(nil).should == nil
    end
  
    it "should allow customizing the precision" do
      number_to_human_size(1234567, :precision => 2).should == '1.18 MB'
      number_to_human_size(3.14159265, :precision => 4).should == '3 Bytes'
      number_to_human_size(1.0123.kilobytes, :precision => 2).should == '1.01 KB'
      number_to_human_size(1.0100.kilobytes, :precision => 4).should == '1.01 KB'
      number_to_human_size(10.000.kilobytes, :precision => 4).should == '10 KB'
    end
  
    it "should allow customizing the precision and separator" do
      number_to_human_size(1.0123.kilobytes, :precision => 2, :separator => ',').should == '1,01 KB'
      number_to_human_size(1.0100.kilobytes, :precision => 4, :separator => ',').should == '1,01 KB'
      number_to_human_size(1000.1.terabytes, :delimiter => '.', :separator => ',').should == '1.000,1 TB'
    end
  end
end