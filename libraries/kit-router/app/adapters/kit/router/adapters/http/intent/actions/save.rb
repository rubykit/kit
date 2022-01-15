# Save a user intent of :intent_type for later user
module Kit::Router::Adapters::Http::Intent::Actions::Save

  def self.call(router_conn:, intent_type:, intent_store: nil)
    intent_type = intent_type ? intent_type.to_sym : nil

    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::Http::Intent.method(:get_intent_strategy),
        Kit::Router::Adapters::Http::Intent.method(:get_intent_value),
        Kit::Router::Adapters::Http::Intent.method(:save_intent_value_in_cookie),
      ],
      ctx:  {
        router_conn:  router_conn,
        intent_type:  intent_type,
        intent_store: intent_store,
      },
    )

    if status == :error && intent_type
      Kit::Error.report_organizer_errors(errors: ctx[:errors])
    end

    [:ok, ctx.slice(:router_conn)]
  end

end
