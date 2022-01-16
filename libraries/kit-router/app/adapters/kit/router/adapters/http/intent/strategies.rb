module Kit::Router::Adapters::Http::Intent::Strategies

  # Save the current url & force a `redirect_to` redirect back to it afterwards.
  #
  # Note: beware of non-standard ENV variables, not all driver might set them.
  #
  # ### References
  # - https://github.com/rack/rack/blob/master/SPEC.rdoc
  # - https://github.com/rack/rack-test/issues/26
  def self.save_url_and_redirect
    stategy = {
      get: ->(router_conn:, **) { [:ok, intent_value: router_conn[:request][:http][:cgi]['PATH_INFO']] },
      use: ->(router_conn:, intent_value:, **) do
        if intent_value && !intent_value.blank?
          Kit::Domain::Endpoints::Http.redirect_to(
            router_conn: router_conn,
            location:    intent_value,
          )
        else
          [:ok]
        end
      end,
    }

    [:ok, intent_strategy: stategy]
  end

  # Save the current url & set :reditect_url to it afterwards.
  #
  # Note: beware of non-standard ENV variables, not all driver might set them.
  #
  # ### References
  # - https://github.com/rack/rack/blob/master/SPEC.rdoc
  # - https://github.com/rack/rack-test/issues/26
  def self.save_url_and_set_redirect_url
    stategy = {
      get: ->(router_conn:, **)                { [:ok, intent_value: router_conn[:request][:http][:cgi]['PATH_INFO']] },
      use: ->(router_conn:, intent_value:, **) do
        if intent_value && !intent_value.blank?
          [:ok, redirect_url: intent_value]
        else
          [:ok]
        end
      end,
    }

    [:ok, intent_strategy: stategy]
  end

=begin
  # Example of a strategy using a request parameter.
  def self.parameter_strategy
    stategy = {
      get: ->(router_conn:, **) { [:ok, intent_value: router_conn.request[:params][:intent]] },
      use: ->(router_conn:, intent_value:, **) do
        # Do something based on the value that was saved.
      end,
    }

    [:ok, intent_strategy: stategy]
  end
=end

end
