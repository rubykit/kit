# Attempt to act on a previously saved user intent of :intent_type
module Kit::Router::Adapters::Http::Intent::Actions::Consume

  def self.call(router_conn:, intent_type:, intent_store: nil)
    status, ctx = Kit::Organizer.call(
      ok:    [
        Kit::Router::Adapters::Http::Intent.method(:get_intent_strategy),
        Kit::Router::Adapters::Http::Intent.method(:load_intent_value_from_cookie),
        Kit::Router::Adapters::Http::Intent.method(:use_intent_value),
        Kit::Router::Adapters::Http::Intent.method(:clear_cookie),
      ],
      error: [
        Kit::Router::Adapters::Http::Intent.method(:clear_cookie),
      ],
      ctx:   {
        router_conn:  router_conn,
        intent_type:  intent_type.to_sym,
        intent_store: intent_store,
      },
    )

    if status == :error
      Kit::Error.report_organizer_errors(errors: ctx[:errors])
      return [:ok, router_conn: router_conn]
    end

    [:ok, ctx.except(:intent_type, :intent_value, :intent_store, :intent_strategy)]
  end

end
