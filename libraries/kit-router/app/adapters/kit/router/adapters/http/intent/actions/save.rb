module Kit::Router::Adapters::Http::Intent::Actions::Save

  # Persist an intent from a query_parameter for `:intent_step` in a cookie.
  def self.call(router_conn:, intent_step:, intent_type:, intent_store: nil)
    intent_type = intent_type ? intent_type.to_sym : nil
    intent_step = intent_step ? intent_step.to_sym : nil

    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::Http::Intent.method(:valid_intent_step?),
        Kit::Router::Adapters::Http::Intent.method(:valid_intent_type?),
        Kit::Router::Adapters::Http::Intent.method(:persist_in_cookie),
      ],
      ctx:  {
        router_conn:  router_conn,
        intent_step:  intent_step,
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
