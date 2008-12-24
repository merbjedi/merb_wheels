# methods copied directly from ActiveSupport
# see included /LICENSE

module MerbWheels #:nodoc:
  module CoreExt #:nodoc:
    module HashExt #:nodoc:
      # Returns a hash that represents the difference between two hashes.
      #
      # Examples:
      #
      #   {1 => 2}.diff(1 => 2)         # => {}
      #   {1 => 2}.diff(1 => 3)         # => {1 => 2}
      #   {}.diff(1 => 2)               # => {1 => 2}
      #   {1 => 2, 3 => 4}.diff(1 => 2) # => {3 => 4}
      def diff(h2)
        self.dup.delete_if { |k, v| h2[k] == v }.merge(h2.dup.delete_if { |k, v| self.has_key?(k) })
      end
      
      # Returns a new hash without the given keys.
      def except(*keys)
        dup.except!(*keys)
      end

      # Replaces the hash without the given keys.
      def except!(*keys)
        keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
        keys.each { |key| delete(key) }
        self
      end

      def with_indifferent_access
        hash = Mash.new(self)
        hash.default = self.default
        hash
      end
      
      # Return a new hash with all keys converted to strings.
      def stringify_keys
        inject({}) do |options, (key, value)|
          options[key.to_s] = value
          options
        end
      end

      # Destructively convert all keys to strings.
      def stringify_keys!
        keys.each do |key|
          self[key.to_s] = delete(key)
        end
        self
      end

      # Return a new hash with all keys converted to symbols.
      def symbolize_keys
        inject({}) do |options, (key, value)|
          options[(key.to_sym rescue key) || key] = value
          options
        end
      end

      # Destructively convert all keys to symbols.
      def symbolize_keys!
        self.replace(self.symbolize_keys)
      end

      alias_method :to_options,  :symbolize_keys
      alias_method :to_options!, :symbolize_keys!
      
      
      # Allows for reverse merging two hashes where the keys in the calling hash take precedence over those
      # in the <tt>other_hash</tt>. This is particularly useful for initializing an option hash with default values:
      #
      #   def setup(options = {})
      #     options.reverse_merge! :size => 25, :velocity => 10
      #   end
      #
      # Using <tt>merge</tt>, the above example would look as follows:
      #
      #   def setup(options = {})
      #     { :size => 25, :velocity => 10 }.merge(options)
      #   end
      #
      # The default <tt>:size</tt> and <tt>:velocity</tt> are only set if the +options+ hash passed in doesn't already
      # have the respective key.
      def reverse_merge(other_hash)
        other_hash.merge(self)
      end

      # Performs the opposite of <tt>merge</tt>, with the keys and values from the first hash taking precedence over the second.
      # Modifies the receiver in place.
      def reverse_merge!(other_hash)
        replace(reverse_merge(other_hash))
      end

      alias_method :reverse_update, :reverse_merge!
      
      # Returns a new hash with +self+ and +other_hash+ merged recursively.
      def deep_merge(other_hash)
        self.merge(other_hash) do |key, oldval, newval|
          oldval = oldval.to_hash if oldval.respond_to?(:to_hash)
          newval = newval.to_hash if newval.respond_to?(:to_hash)
          oldval.class.to_s == 'Hash' && newval.class.to_s == 'Hash' ? oldval.deep_merge(newval) : newval
        end
      end

      # Returns a new hash with +self+ and +other_hash+ merged recursively.
      # Modifies the receiver in place.
      def deep_merge!(other_hash)
        replace(deep_merge(other_hash))
      end
      
      # Returns a new hash with only the given keys.
      def slice(*keys)
        keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
        hash = self.class.new
        keys.each { |k| hash[k] = self[k] if has_key?(k) }
        hash
      end

      # Replaces the hash with only the given keys.
      def slice!(*keys)
        replace(slice(*keys))
      end
    end
  end
end

Hash.send :include, MerbWheels::CoreExt::HashExt