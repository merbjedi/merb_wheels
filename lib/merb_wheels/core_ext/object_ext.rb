# methods copied directly from ActiveSupport
# see included /LICENSE

module MerbWheels #:nodoc:
  module CoreExt #:nodoc:
    module ObjectExt #:nodoc:
      # An object is present if it's not blank.
      def present?
        !blank?
      end
      
      # Returns +value+ after yielding +value+ to the block. This simplifies the
      # process of constructing an object, performing work on the object, and then
      # returning the object from a method. It is a Ruby-ized realization of the K
      # combinator, courtesy of Mikael Brockman.
      #
      # ==== Examples
      #
      #  # Without returning
      #  def foo
      #    values = []
      #    values << "bar"
      #    values << "baz"
      #    return values
      #  end
      #
      #  foo # => ['bar', 'baz']
      #
      #  # returning with a local variable
      #  def foo
      #    returning values = [] do
      #      values << 'bar'
      #      values << 'baz'
      #    end
      #  end
      #
      #  foo # => ['bar', 'baz']
      #  
      #  # returning with a block argument
      #  def foo
      #    returning [] do |values|
      #      values << 'bar'
      #      values << 'baz'
      #    end
      #  end
      #  
      #  foo # => ['bar', 'baz']
      def returning(value)
        yield(value)
        value
      end
      
      # Tries to send the method only if object responds to it. Return +nil+ otherwise.
      # 
      # ==== Example :
      # 
      # # Without try
      # @person ? @person.name : nil
      # 
      # With try
      # @person.try(:name)
      def try(method_id, *args, &block)
        respond_to?(method_id) ? send(method_id, *args, &block) : nil
      end
    end
  end
end

Object.send :include, MerbWheels::CoreExt::ObjectExt