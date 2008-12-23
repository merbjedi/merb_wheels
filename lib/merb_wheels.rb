require 'merb-core'
require 'merb-helpers'

module MerbWheels
  module Plugin
    @@root_dir = File.dirname(__FILE__) / "merb_wheels"
    def self.load
      # load core_ext extensions
       Dir[@@root_dir / "core_ext" / "*.rb"].each do |file_path|
        Kernel.load(file_path)
      end
      
      # load helpers
      helpers_dir = @@root_dir / "helpers"
      Kernel.load(helpers_dir / "text_helpers.rb")
    end    
  end
end

MerbWheels::Plugin.load

# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:merb_wheels] = {}
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
  end
  
  Merb::BootLoader.after_app_loads do
    # add helpers to view
    ::Merb::GlobalHelpers.send :include, MerbWheels::Helpers::TextHelpers
  end
  
  Merb::Plugins.add_rakefiles "merb_wheels/merbtasks"
end