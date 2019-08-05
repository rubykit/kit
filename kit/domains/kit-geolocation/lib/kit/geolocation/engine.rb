module Kit
  module Geolocation
    class Engine < ::Rails::Engine
      isolate_namespace Kit::Geolocation

      config.assets.paths << File.expand_path("../../../../app/cells", __FILE__)

      initializer :kit_geolocation_engine do
        ::ActiveAdmin.application.load_paths += Dir[File.expand_path("../../../../app/admin", __FILE__)]
      end
    end
  end
end
