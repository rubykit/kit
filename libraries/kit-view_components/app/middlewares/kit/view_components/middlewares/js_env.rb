# Set :js_env on RouterConn :metadata.
#
# For http: this can be dumped as a js hash in html page by Kit::ViewComponents::Components::JsEnvComponent
module Kit::ViewComponents::Middlewares::JsEnv

  def self.call(router_conn:)
    router_conn[:metadata][:js_env] = {
      env_type:  Rails.env.to_s,

      kit:       {
        route_id:    router_conn.route_id,
        endpoint_id: router_conn.endpoint[:id],
      },

      analytics: {
        segment_key: ENV['ANALYTICS_SEGMENT_SOURCE_CLIENT_KEY'],
        google_mid:  ENV['ANALYTICS_GA_MID'],
      },
    }

    [:ok, router_conn: router_conn]
  end

end
