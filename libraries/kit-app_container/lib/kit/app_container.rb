module Kit # rubocop:disable Style/Documentation
end

# AppContainer allows to mount various Domains (engines) in order to expose them to the outside world, or each-other.
# TODO: add documentation for `AppContainer`
module Kit::AppContainer

  def self.config_application(context:)
    context.config.load_defaults 6.0

    context.config.action_controller.permit_all_parameters = true
  end

end

require 'kit/app_container/engine'
