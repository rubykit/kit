module Kit::Router::Adapters::Http::Intent::Strategies

  def self.save_url_and_redirect
    stategy = {
      get: ->(router_conn:, **) { [:ok, intent_value: router_conn[:request][:http][:cgi]['REQUEST_PATH']] },
      use: ->(router_conn:, intent_value:, **) do
        Kit::Domain::Endpoints::Http.redirect_to(
          router_conn: router_conn,
          location:    intent_value,
        )
      end,
    }

    [:ok, intent_strategy: stategy]
  end

  def self.save_url_and_set_redirect_url
    stategy = {
      get: ->(router_conn:, **)                { [:ok, intent_value: router_conn[:request][:http][:cgi]['REQUEST_PATH']] },
      use: ->(router_conn:, intent_value:, **) { [:ok, redirect_url: intent_value] },

    }

    [:ok, intent_strategy: stategy]
  end

  def self.parameter_strategy
    stategy = {
      get: ->(router_conn:, **) { [:ok, intent_value: router_conn.request[:params][:intent]] },
      use: ->(router_conn:, intent_value:, **) do
        # Do something based on the value that was saved.
      end,
    }

    [:ok, intent_strategy: stategy]
  end

end
