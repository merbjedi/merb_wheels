# methods copied directly from ActiveSupport
# see included /LICENSE

module MerbWheels #:nodoc:
  module CoreExt #:nodoc:
    module IntegerExt #:nodoc:
      def multiple_of?(number)
        self % number == 0
      end

      def even?
        multiple_of? 2
      end if RUBY_VERSION < '1.9'

      def odd?
        !even?
      end if RUBY_VERSION < '1.9'
    end
  end
end
      
Integer.send :include, MerbWheels::CoreExt::IntegerExt