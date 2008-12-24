require File.dirname(__FILE__) + '/../spec_helper'

describe Array do
  describe "#from" do
    it "should return the entries from a given index" do
      %w( a b c d ).from(0).should == %w( a b c d )
      %w( a b c d ).from(2).should == %w( c d )
      %w( a b c d ).from(10).should == nil
    end
  end
  
  describe "#to" do
    it "should return all the entries up to a given index" do
      %w( a b c d ).to(0).should == %w( a )
      %w( a b c d ).to(2).should == %w( a b c )
      %w( a b c d ).to(10).should == %w( a b c d )
    end
  end
  
  describe "#in_groups_of" do
    it "should segment an array into equal size groups if the array size is exactly dividable by the group size" do
      groups = []
      ('a'..'i').to_a.in_groups_of(3) do |group|
        groups << group
      end

      groups.should == [%w(a b c), %w(d e f), %w(g h i)]
      ('a'..'i').to_a.in_groups_of(3).should == [%w(a b c), %w(d e f), %w(g h i)]
    end
    
    it "should segment an array and add nil padded elements in the last group if the size doesnt match up exactly" do
      groups = []
      ('a'..'g').to_a.in_groups_of(3) do |group|
        groups << group
      end

      groups.should == [%w(a b c), %w(d e f), ['g', nil, nil]]
    end
    
    it "should allow customization of padded elements" do
      groups = []

      ('a'..'g').to_a.in_groups_of(3, 'foo') do |group|
        groups << group
      end

      groups.should == [%w(a b c), %w(d e f), ['g', 'foo', 'foo']]
    end
    
    it "should produce groups of unequal size if padding is turned off specifically" do
      groups = []

      ('a'..'g').to_a.in_groups_of(3, false) do |group|
        groups << group
      end

      groups.should == [%w(a b c), %w(d e f), ['g']]
    end
    
    it "should handle empty arrays" do
      [].in_groups_of(3).should == []
    end
  end
  
  
  describe "#in_groups" do
    it "should always return an array matching the group size" do
      array = (1..7).to_a

      1.upto(array.size + 1) do |number|
        array.in_groups(number).size.should == number
      end
    end
    
    it "should slice up an empty array into other empty arrays" do
      [].in_groups(3).should == [[], [], []]
    end
    
    it "should take a block that iterates over the same results returned" do
      array = (1..9).to_a
      groups = []

      array.in_groups(3) do |group|
        groups << group
      end

      groups.should == array.in_groups(3)
    end
    
    it "should segment arrays that match perfectly" do
      (1..9).to_a.in_groups(3).should == [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    end
    
    it "should add padding to arrays that don't match the group size exactly" do
      array = (1..7).to_a
      array.in_groups(3).should == [[1, 2, 3], [4, 5, nil], [6, 7, nil]]
      array.in_groups(3, 'foo').should == [[1, 2, 3], [4, 5, 'foo'], [6, 7, 'foo']]
    end
    
    it "should not add padding if specified not to" do
      (1..7).to_a.in_groups(3, false).should == [[1, 2, 3], [4, 5], [6, 7]]
    end
  end
  
  describe "#split" do
    it "should handle empty array" do
      [].split(0).should == [[]]
    end
    
    it "should split an array using the argument as the pivot" do
      [1, 2, 3, 4, 5].split(3).should == [[1, 2], [4, 5]]
      [1, 2, 3, 4, 5].split(0).should == [[1, 2, 3, 4, 5]]
    end
    
    it "should split an array using an evaluated block output as the pivots" do
      (1..10).to_a.split { |i| i % 3 == 0 }.should == [[1, 2], [4, 5], [7, 8], [10]]
    end
    
    it "should handle edge values" do
      [1, 2, 3, 4, 5].split(1).should == [[], [2, 3, 4, 5]]
      [1, 2, 3, 4, 5].split(5).should == [[1, 2, 3, 4], []]
      [1, 2, 3, 4, 5].split { |i| i == 1 || i == 5 }.should == [[], [2, 3, 4], []]
    end
  end
  
  describe "#extract_options!" do
    it "return the last parameter of an array as a hash" do
      [].extract_options!.should == {}
      [1].extract_options!.should == {}
      [{:a=>:b}].extract_options!.should == {:a=>:b}
      [1, {:a=>:b}].extract_options!.should == {:a=>:b}
    end
  end
  
  describe "#rand" do
    it "should pick a random element out of an array" do
      [].rand.should == nil

      Kernel.should_receive(:rand).with(1).and_return(0)
      ['x'].rand.should == "x"

      Kernel.should_receive(:rand).with(3).and_return(1)
      [1, 2, 3].rand.should == 2
    end
  end
  
end