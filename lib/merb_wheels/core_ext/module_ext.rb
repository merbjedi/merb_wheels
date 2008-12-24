# methods copied directly from ActiveSupport
# see included /LICENSE

module MerbWheels #:nodoc:
  module CoreExt #:nodoc:
    module ModuleExt #:nodoc:
      def mattr_reader(*syms)
        syms.each do |sym|
          next if sym.is_a?(Hash)
          class_eval(<<-EOS, __FILE__, __LINE__)
            unless defined? @@#{sym}
              @@#{sym} = nil
            end
      
            def self.#{sym}
              @@#{sym}
            end

            def #{sym}
              @@#{sym}
            end
          EOS
        end
      end

      def mattr_writer(*syms)
        options = syms.extract_options!
        syms.each do |sym|
          class_eval(<<-EOS, __FILE__, __LINE__)
            unless defined? @@#{sym}
              @@#{sym} = nil
            end
      
            def self.#{sym}=(obj)
              @@#{sym} = obj
            end
      
            #{"
            def #{sym}=(obj)
              @@#{sym} = obj
            end
            " unless options[:instance_writer] == false }
          EOS
        end
      end

      def mattr_accessor(*syms)
        mattr_reader(*syms)
        mattr_writer(*syms)
      end
    end
  end
end

Module.send :include, MerbWheels::CoreExt::ModuleExt