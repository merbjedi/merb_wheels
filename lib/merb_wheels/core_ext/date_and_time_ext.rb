# methods copied directly from ActiveSupport
# see included /LICENSE

# TODO: add any useful activesupport datetime helpers that Merb doesnt have
module MerbWheels #:nodoc:
  module CoreExt #:nodoc:
    module DateExt #:nodoc:
    end

    module TimeExt #:nodoc:
    end

    module DateTimeExt #:nodoc:
    end

  end
end


# String.send :include, MerbWheels::CoreExt::DateExt
# String.send :include, MerbWheels::CoreExt::TimeExt
# String.send :include, MerbWheels::CoreExt::DateTimeExt