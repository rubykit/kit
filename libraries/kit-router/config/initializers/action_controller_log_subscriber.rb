if defined?(Rails)
  require 'action_controller/log_subscriber'

  ActionController::LogSubscriber.class_eval do

    # Changes 2 things:
    #   - hides kit default route parameters as it can contain a lot of data.
    #   - display the route id instead of rails controller + action (since it's always the same)
    #
    # ### References
    # - https://github.com/rails/rails/blob/v6.1.4.1/actionview/lib/action_view/log_subscriber.rb
    def start_processing(event)
      return unless logger.info?

      payload = event.payload
      params  = payload[:params]
        .except(*ActionController::LogSubscriber::INTERNAL_PARAMS)
        .reject { |k, _v| k.to_s.starts_with?('kit_') }

      format = payload[:format]
      format = format.to_s.upcase if format.is_a?(Symbol)
      format = '*/*' if !format

      kit_target = payload[:request].path_parameters[:kit_router_target] rescue {} # rubocop:disable Style/RescueModifier
      target     = kit_target&.dig(:route_id) || "#{ payload[:controller] }##{ payload[:action] } "

      info "Processing by #{ target } as #{ format }"
      info "  Parameters: #{ params.inspect }" unless params.empty?
    end

  end

end
