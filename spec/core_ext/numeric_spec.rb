require File.dirname(__FILE__) + '/../spec_helper'

describe Numeric do
  it "should provide sizes for common filesize options" do
    1024.bytes.should == 1.kilobyte
    1024.kilobytes.should == 1.megabyte
    3584.0.kilobytes.should == 3.5.megabytes
    3584.0.megabytes.should == 3.5.gigabytes
    (1.kilobyte ** 4).should == 1.terabyte
    (1024.kilobytes + 2.megabytes).should == 3.megabytes
    (2.gigabytes / 4).should == 512.megabytes
    (256.megabytes * 20 + 5.gigabytes).should == 10.gigabytes
    (1.kilobyte ** 5).should == 1.petabyte
    (1.kilobyte ** 6).should == 1.exabyte
  end
end
