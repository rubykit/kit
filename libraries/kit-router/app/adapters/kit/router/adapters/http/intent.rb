module Kit::Router::Adapters::Http::Intent

  def self.persist_in_cookie(router_conn:, intent_step:, intent_type:)
    return [:ok] if !intent_type

    router_conn.response[:http][:cookies][intent_step.to_sym] = { value: intent_type.to_sym, encrypted: true }

    [:ok, router_conn: router_conn]
  end

  def self.load_from_cookie(router_conn:, intent_step:)
    intent_type = router_conn.request[:http][:cookies].dig(intent_step.to_sym, :value)
    intent_type = intent_type.to_sym if intent_type

    [:ok, intent_type: intent_type]
  end

  def self.clean_cookie(router_conn:, intent_step:)
    router_conn.response[:http][:cookies][intent_step] = { value: nil, encrypted: true }

    [:ok, router_conn: router_conn]
  end

  def self.valid_intent_step?(intent_step:, intent_store: nil)
    intent_store ||= Kit::Router::Adapters::Http::Intent::Store.default_intent_store
    intent_step    = intent_step.to_sym

    if intent_store[:steps].include?(intent_step)
      [:ok]
    else
      [:error, { code: :auth_invalid_intent_step, detail: "Unknown intent step `#{ intent_step }`" }]
    end
  end

  def self.valid_intent_type?(intent_type:, intent_store: nil)
    intent_store ||= Kit::Router::Adapters::Http::Intent::Store.default_intent_store

    if intent_type && (value = intent_store[:types][intent_type.to_sym])
      [:ok, intent_callable: value]
    else
      [:error, { code: :auth_invalid_intent_type, detail: "Invalid intent type `#{ intent_type }`" }]
    end
  end

end
