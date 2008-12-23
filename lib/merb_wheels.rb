require 'merb-core'
require 'merb-helpers'

module MerbWheels
  module Plugin
    @@root_dir = File.dirname(__FILE__) / "merb_wheels"
    def self.load
      Kernel.load(@@root_dir / "ordered_hash.rb")
      Kernel.load(@@root_dir / "util.rb")
      
      # load core_ext extensions
       Dir[@@root_dir / "core_ext" / "*.rb"].each do |file_path|
        Kernel.load(file_path)
      end
      
      # load view helpers
      Dir[@@root_dir / "helpers" / "*.rb"].each do |file_path|
        Kernel.load(file_path)
      end
    end    
  end
end

# load plugins
MerbWheels::Plugin.load

# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:merb_wheels] = {}
  
  Merb::BootLoader.before_app_loads do
    # make helpers available to the view
    ::Merb::GlobalHelpers.send :include, MerbWheels::Helpers::DateHelpers
    ::Merb::GlobalHelpers.send :include, MerbWheels::Helpers::JavascriptHelpers
    ::Merb::GlobalHelpers.send :include, MerbWheels::Helpers::NumberHelpers
    ::Merb::GlobalHelpers.send :include, MerbWheels::Helpers::SanitizeHelpers
    ::Merb::GlobalHelpers.send :include, MerbWheels::Helpers::TagHelpers
    ::Merb::GlobalHelpers.send :include, MerbWheels::Helpers::TextHelpers
    ::Merb::GlobalHelpers.send :include, MerbWheels::Helpers::UrlHelpers
  end
  
  Merb::BootLoader.after_app_loads do
  end
  
  Merb::Plugins.add_rakefiles "merb_wheels/merbtasks"
end