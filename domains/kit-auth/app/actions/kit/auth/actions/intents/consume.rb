module Kit::Auth::Actions::Intents::Consume

  def self.call(router_conn:, intent_step:, intent_store: nil)
    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Services::Intent.method(:valid_intent_step?),
        Kit::Auth::Services::Intent.method(:load_from_cookie),
        Kit::Auth::Services::Intent.method(:valid_intent_type?),
        [:ctx_call, :intent_callable],
        Kit::Auth::Services::Intent.method(:clean_cookie),
      ],
      ctx:  {
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
