module Kit
  module Domain

    def self.config_domain(namespace:, context:, file:)
      initializer_name = "#{ namespace.name.underscore.gsub('/', '_') }_engine"
      context.initializer initializer_name do
        ::ActiveAdmin.application.load_paths += Dir[File.expand_path("../../../app/admin", file)]
      end
    end

  end
end

require "kit/domain/engine"
