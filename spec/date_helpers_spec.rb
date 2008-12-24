require File.dirname(__FILE__) + '/spec_helper'

describe "Date View Helpers" do
  include Merb::GlobalHelpers

  describe "distance_of_time_in_words" do
    def check_distance_of_time_in_words(from, to=nil)
      to ||= from

      # 0..1 with include_seconds
      distance_of_time_in_words(from, to + 0.seconds, true).should == "less than 5 seconds"
      distance_of_time_in_words(from, to + 4.seconds, true).should == "less than 5 seconds"
      distance_of_time_in_words(from, to + 5.seconds, true).should == "less than 10 seconds"
      distance_of_time_in_words(from, to + 9.seconds, true).should == "less than 10 seconds"
      distance_of_time_in_words(from, to + 10.seconds, true).should == "less than 20 seconds"
      distance_of_time_in_words(from, to + 19.seconds, true).should == "less than 20 seconds"
      distance_of_time_in_words(from, to + 20.seconds, true).should == "half a minute"
      distance_of_time_in_words(from, to + 39.seconds, true).should == "half a minute"
      distance_of_time_in_words(from, to + 40.seconds, true).should == "less than a minute"
      distance_of_time_in_words(from, to + 59.seconds, true).should == "less than a minute"
      distance_of_time_in_words(from, to + 60.seconds, true).should == "1 minute"
      distance_of_time_in_words(from, to + 89.seconds, true).should == "1 minute"

      # First case 0..1
      distance_of_time_in_words(from, to + 0.seconds).should == "less than a minute"
      distance_of_time_in_words(from, to + 29.seconds).should == "less than a minute"
      distance_of_time_in_words(from, to + 30.seconds).should == "1 minute"
      distance_of_time_in_words(from, to + 1.minutes + 29.seconds).should == "1 minute"

      # 2..44
      distance_of_time_in_words(from, to + 1.minutes + 30.seconds).should == "2 minutes"
      distance_of_time_in_words(from, to + 44.minutes + 29.seconds).should == "44 minutes"

      # 45..89
      distance_of_time_in_words(from, to + 44.minutes + 30.seconds).should == "about 1 hour"
      distance_of_time_in_words(from, to + 89.minutes + 29.seconds).should == "about 1 hour"

      # 90..1439
      distance_of_time_in_words(from, to + 89.minutes + 30.seconds).should == "about 2 hours"
      distance_of_time_in_words(from, to + 23.hours + 59.minutes + 29.seconds).should == "about 24 hours"

      # 1440..2879
      distance_of_time_in_words(from, to + 23.hours + 59.minutes + 30.seconds).should == "1 day"
      distance_of_time_in_words(from, to + 47.hours + 59.minutes + 29.seconds).should == "1 day"

      # 2880..43199
      distance_of_time_in_words(from, to + 47.hours + 59.minutes + 30.seconds).should == "2 days"
      distance_of_time_in_words(from, to + 29.days + 23.hours + 59.minutes + 29.seconds).should == "29 days"

      # 43200..86399
      distance_of_time_in_words(from, to + 29.days + 23.hours + 59.minutes + 30.seconds).should == "about 1 month"
      distance_of_time_in_words(from, to + 59.days + 23.hours + 59.minutes + 29.seconds).should == "about 1 month"

      # 86400..525599
      distance_of_time_in_words(from, to + 59.days + 23.hours + 59.minutes + 30.seconds).should == "2 months"
      distance_of_time_in_words(from, to + 1.years - 31.seconds).should == "12 months"

      # 525600..1051199
      distance_of_time_in_words(from, to + 1.years - 30.seconds).should == "12 months"
      distance_of_time_in_words(from, to + 2.years - 31.seconds).should == "about 1 year"

      # > 1051199
      distance_of_time_in_words(from, to + 2.years + 30.seconds).should == "over 2 years"
      distance_of_time_in_words(from, to + 10.years).should == "over 10 years"

      # test to < from
      distance_of_time_in_words(from + 4.hours, to).should == "about 4 hours"
      distance_of_time_in_words(from + 19.seconds, to, true).should == "less than 20 seconds"
    end
    
    # TODO
    # it "should work with time zones" do
    #   from = Time.mktime(2004, 6, 6, 21, 45, 0)
    #   check_distance_of_time_in_words(from.in_time_zone('Alaska'))
    #   check_distance_of_time_in_words(from.in_time_zone('Hawaii'))
    # end
  
    it "should work with dates" do
      start_date = Date.new 1975, 1, 31
      end_date = Date.new 1977, 1, 31
      distance_of_time_in_words(start_date, end_date).should == "over 2 years"
    end
  
    it "should work with integers" do
      distance_of_time_in_words(59).should == "less than a minute"
      distance_of_time_in_words(60*60).should == "about 1 hour"
      distance_of_time_in_words(0, 59).should == "less than a minute"
      distance_of_time_in_words(60*60, 0).should == "about 1 hour"
    end
  end

  describe "time_ago_in_words" do
    it "should show the time ago in words" do
      time_ago_in_words(1.year.ago - 1.day).should == "about 1 year"
    end
  end
end