# Set :js_env on RouterRequest :metadata.
#
# For http: this can be dumped as a js hash in html page by Kit::Domain::Components::JsEnvComponent
module Kit::Domain::Middlewares::JsEnv

  def self.call(router_request:)
    router_request[:metadata][:js_env] = {
      current_env: Rails.env.to_s,

      kit:         {
        route_id:     router_request.dig(:target, :route_id),
        endpoint_uid: router_request.dig(:target, :endpoint_uid),
      },

      analytics:   {
        segment_key: ENV['ANALYTICS_SEGMENT_SOURCE_CLIENT_KEY'],
        google_mid:  ENV['ANALYTICS_GA_MID'],
      },
    }

    [:ok, router_request: router_request]
  end

end
