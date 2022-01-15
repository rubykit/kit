module Kit::Router::Adapters::Http::Intent::Actions::Consume

  def self.call(router_conn:, intent_step:, intent_store: nil)
    status, ctx = Kit::Organizer.call(
      ok:    [
        Kit::Router::Adapters::Http::Intent.method(:valid_intent_step?),
        Kit::Router::Adapters::Http::Intent.method(:load_from_cookie),
        Kit::Router::Adapters::Http::Intent.method(:valid_intent_type?),
        [:ctx_call, :intent_callable],
        Kit::Router::Adapters::Http::Intent.method(:clean_cookie),
      ],
      error: [
        Kit::Router::Adapters::Http::Intent.method(:clean_cookie),
      ],
      ctx:   {
        router_conn:  router_conn,
        intent_step:  intent_step.to_sym,
        intent_store: intent_store,
      },
    )

    if status == :error
      Kit::Error.report_organizer_errors(errors: ctx[:errors])
      return [:ok, router_conn: router_conn]
    end

    [:ok, ctx.except(:intent_step, :intent_type, :intent_store, :intent_callable)]
  end

end
