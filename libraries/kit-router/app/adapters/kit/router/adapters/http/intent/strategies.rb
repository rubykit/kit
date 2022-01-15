module Kit::Router::Adapters::Http::Intent::Strategies::Parameter

  def self.parameter_strategy
    stategy = {
      get: ->(router_conn:, **) { [:ok, intent_value: router_conn.request[:params][:intent]] },
      use: ->(router_conn:, intent_value:, **) do
        # Do something based on the value that was saved.
      end,
    }

    [:ok, intent_strategy: stategy]
  end

  def self.redirect_back
    stategy = {
      get: ->(router_conn:, **) { [:ok, intent_value: router_conn.request[:params][:intent]] },
      use: ->(router_conn:, intent_value:, **) do
        Kit::Domain::Endpoints::Http.redirect_to(
          router_conn: router_conn,
          location:    intent_value,
        )
      end,
    }

    [:ok, intent_strategy: stategy]
  end

end
