# methods copied directly from ActiveSupport
# see included /LICENSE

module MerbWheels #:nodoc:
  module CoreExt #:nodoc:
    module RangeExt #:nodoc:
      # Compare two ranges and see if they overlap eachother
      #  (1..5).overlaps?(4..6) # => true
      #  (1..5).overlaps?(7..9) # => false
      def overlaps?(other)
        include?(other.first) || other.include?(first)
      end
      
      # Extends the default Range#include? to support range comparisons.
      #  (1..5).include?(1..5) # => true
      #  (1..5).include?(2..3) # => true
      #  (1..5).include?(2..6) # => false
      #
      # The native Range#include? behavior is untouched.
      #  ("a".."f").include?("c") # => true
      #  (5..9).include?(11) # => false
      def include_with_range?(value)
        if value.is_a?(::Range)
          operator = exclude_end? ? :< : :<=
          end_value = value.exclude_end? ? last.succ : last
          include?(value.first) && (value.last <=> end_value).send(operator, 0)
        else
          include_without_range?(value)
        end
      end
    end
  end
end

Range.send :include, MerbWheels::CoreExt::RangeExt