module MerbWheels #:nodoc:
  module Monkey #:nodoc:
    module HashExtensions #:nodoc:
      # Performs the opposite of <tt>merge</tt>, with the keys and values from the first hash taking precedence over the second.
      def reverse_merge(other_hash)
        other_hash.merge(self)
      end

      # Performs the opposite of <tt>merge</tt>, with the keys and values from the first hash taking precedence over the second.
      # Modifies the receiver in place.
      def reverse_merge!(other_hash)
        replace(reverse_merge(other_hash))
      end

      alias_method :reverse_update, :reverse_merge!
    end
  end
end
