module Kit
  module AppContainer

    def self.config_application(context:)
      context.config.load_defaults 6.0

      context.config.action_controller.permit_all_parameters = true
    end

  end
end

require "kit/app_container/engine"
