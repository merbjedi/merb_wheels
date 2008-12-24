require File.dirname(__FILE__) + '/../spec_helper'

describe Hash do
  before(:each) do
    @strings = { 'a' => 1, 'b' => 2 }
    @symbols = { :a  => 1, :b  => 2 }
    @mixed   = { :a  => 1, 'b' => 2 }
    @fixnums = {  0  => 1,  1  => 2 }
    if RUBY_VERSION < '1.9.0'
      @illegal_symbols = { "\0" => 1, "" => 2, [] => 3 }
    else
      @illegal_symbols = { [] => 3 }
    end
  end
  
  
  it "should have methods" do
    h = {}
    h.should respond_to(:symbolize_keys)
    h.should respond_to(:symbolize_keys!)
    h.should respond_to(:stringify_keys)
    h.should respond_to(:stringify_keys!)
    h.should respond_to(:to_options)
    h.should respond_to(:to_options!)
  end

  describe "#symbolize_keys" do
    it "should create a copy of the hash with keys as symbols" do
      @symbols.symbolize_keys.should == @symbols
      @strings.symbolize_keys.should == @symbols
      @mixed.symbolize_keys.should == @symbols
    end
    
    it "should preserve keys that cant be symbolized" do
      @illegal_symbols.symbolize_keys.should ==  @illegal_symbols
    end
    
    it "should preserve fixnum keys" do
      @fixnums.symbolize_keys.should == @fixnums
    end
  end
  
  describe "#symbolize_keys!" do
    it "should convert all keys to symbols (destructively)" do
      @symbols.symbolize_keys!.should == @symbols
      @strings.symbolize_keys!.should == @symbols
      @mixed.symbolize_keys!.should == @symbols

      @symbols.should == @symbols
      @strings.should == @symbols
      @mixed.should == @symbols
    end
    
    it "should preserve keys that cant be symbolized" do
      @illegal_symbols.dup.symbolize_keys!.should == @illegal_symbols
    end
    
    it "should preserve fixnum keys" do
      @fixnums.dup.symbolize_keys!.should == @fixnums
    end
  end
  
  describe "#stringify_keys" do
    it "should return a new hash with all the keys converted to strings" do
      @symbols.stringify_keys.should == @strings
      @strings.stringify_keys.should == @strings
      @mixed.stringify_keys.should == @strings
    end
  end
  
  describe "#stringify_keys!" do
    it "should convert all the keys to strings (destructively)" do
      @symbols.stringify_keys!.should == @strings
      @strings.stringify_keys!.should == @strings
      @mixed.stringify_keys!.should == @strings
      
      @symbols.should == @strings
      @strings.should == @strings
      @mixed.should == @strings
    end
  end
  
  describe "#with_indifferent_access" do
    it "should return a Mash of the current hash" do
      @strings_mash = @strings.with_indifferent_access
      @symbols_mash = @symbols.with_indifferent_access
      @mixed_mash   = @mixed.with_indifferent_access
      
      @strings_mash.fetch('a').should == 1
      @strings_mash.fetch(:a.to_s).should == 1
      @strings_mash.fetch(:a).should == 1
      
      @strings_mash.values_at('a', 'b').should == [1, 2]
      @strings_mash.values_at(:a, :b).should == [1, 2]
      @symbols_mash.values_at('a', 'b').should == [1, 2]
      @symbols_mash.values_at(:a, :b).should == [1, 2]
      @mixed_mash.values_at('a', 'b').should == [1, 2]
      @mixed_mash.values_at(:a, :b).should == [1, 2]
    end
    
    it "should not change keys to string" do
      original = {Object.new => 2, 1 => 2, [] => true}
      indiff = original.with_indifferent_access
      indiff.keys.any? {|k| k.kind_of? String}.should be_false
    end
  end
  
  describe "#deep_merge" do
    it "should merge recursive hash" do
      hash_1 = { :a => "a", :b => "b", :c => { :c1 => "c1", :c2 => "c2", :c3 => { :d1 => "d1" } } }
      hash_2 = { :a => 1, :c => { :c1 => 2, :c3 => { :d2 => "d2" } } }
      expected = { :a => 1, :b => "b", :c => { :c1 => 2, :c2 => "c2", :c3 => { :d1 => "d1", :d2 => "d2" } } }
      
      hash_1.deep_merge(hash_2).should == expected

      hash_1.deep_merge!(hash_2)
      hash_1.should == expected
    end
  end
  
  describe "#reverse_merge" do
    it "should merge 2 hashes in reverse" do
      defaults = { :a => "x", :b => "y", :c => 10 }.freeze
      options  = { :a => 1, :b => 2 }
      expected = { :a => 1, :b => 2, :c => 10 }

      # Should merge defaults into options, creating a new hash.
      options.reverse_merge(defaults).should == expected
      options.should_not == expected

      # Should merge! defaults into options, replacing options.
      merged = options.dup
      merged.reverse_merge!(defaults).should == expected
      merged.should == expected

      # Should be an alias for reverse_merge!
      merged = options.dup
      merged.reverse_update(defaults).should == expected
      merged.should == expected
    end
  end
  
  describe "#diff" do
    it "should find the differences between 2 hashes" do
      { :a => 2, :b => 5 }.diff({ :a => 1, :b => 5 }).should == {:a => 2}
    end
  end
  
  describe "#slice" do
    it "should slice up a hash" do
      original = { :a => 'x', :b => 'y', :c => 10 }
      expected = { :a => 'x', :b => 'y' }

      # Should return a new hash with only the given keys.
      original.slice(:a, :b).should == expected
      original.should_not == expected

      # Should replace the hash with only the given keys.
      original.slice!(:a, :b).should == expected
      original.should == expected
    end
    
    it "should slice up a hash with an array key" do
      original = { :a => 'x', :b => 'y', :c => 10, [:a, :b] => "an array key" }
      expected = { [:a, :b] => "an array key", :c => 10 }

      # Should return a new hash with only the given keys when given an array key.
      original.slice([:a, :b], :c).should == expected
      original.should_not == expected

      # Should replace the hash with only the given keys when given an array key.
      original.slice!([:a, :b], :c).should == expected
      original.should == expected
    end
    
    it "should slice up a hash with splatted keys" do
      original = { :a => 'x', :b => 'y', :c => 10, [:a, :b] => "an array key" }
      expected = { :a => 'x', :b => "y" }

      # Should grab each of the splatted keys.
      original.slice(*[:a, :b]).should == expected
    end
    
    it "should slice up an indifferent hash" do
      original = { :a => 'x', :b => 'y', :c => 10 }.with_indifferent_access
      expected = { :a => 'x', :b => 'y' }.with_indifferent_access

      [['a', 'b'], [:a, :b]].each do |keys|
        # Should return a new hash with only the given keys.
        original.slice(*keys).should == expected
        original.should_not == expected

        # Should replace the hash with only the given keys.
        copy = original.dup
        copy.slice!(*keys).should == expected
        copy.should == expected
      end
    end
    
    it "should slice up an indifferent hash by symbol" do
      original = {'login' => 'bender', 'password' => 'shiny', 'stuff' => 'foo'}
      original = original.with_indifferent_access

      slice = original.slice(:login, :password)

      slice[:login].should == 'bender'
      slice['login'].should == 'bender'
    end
  end
  
  describe "#except" do
    it "should exclude keys from a hash" do
      original = { :a => 'x', :b => 'y', :c => 10 }
      expected = { :a => 'x', :b => 'y' }

      # Should return a new hash with only the given keys.
      original.except(:c).should == expected
      original.should_not == expected

      # Should replace the hash with only the given keys.
      original.except!(:c).should == expected
      original.should == expected
    end
    
    it "should preserve a frozen hash" do
      original = { :a => 'x', :b => 'y' }
      original.freeze
      lambda {
        original.except(:a)
      }.should_not raise_error
    end
  end
  
end
  