# Logic to persist a user intent through a series of actions.
module Kit::Router::Adapters::Http::Intent

  # Get the registered intent Strategy for :intent_type
  def self.get_intent_strategy(intent_type:, intent_store: nil)
    intent_store  ||= Kit::Router::Adapters::Http::Intent::Store.default_intent_store
    intent_strategy = intent_store[intent_type.to_sym]

    if intent_strategy
      [:ok, intent_strategy: intent_strategy]
    else
      [:error, { code: :router_unknown_intent_type, detail: "Unknown intent type `#{ intent_type }`" }]
    end
  end

  # Use :intent_strategy to retrieve an :intent_value
  def self.get_intent_value(router_conn:, intent_strategy:)
    intent_strategy[:get].call(router_conn: router_conn)
  end

  # Use :intent_strategy to act on an :intent_value
  def self.use_intent_value(router_conn:, intent_value:, intent_strategy:)
    intent_strategy[:use].call(router_conn: router_conn, intent_value: intent_value)
  end

  # ----------------------------------------------------------------------------

  # Persist the tupple [:intent_type, :intent_value] in a cookie for later user
  def self.save_intent_value_in_cookie(router_conn:, intent_type:, intent_value:)
    return [:ok] if !intent_type

    cookie_name = get_cookie_name(intent_type: intent_type)[1][:cookie_name]

    router_conn.response[:http][:cookies][cookie_name] = { value: intent_value.to_s, encrypted: true }

    [:ok, router_conn: router_conn]
  end

  # Retrieve the cookie (if set) containing the :intent_value of an :intent_type
  def self.load_intent_value_from_cookie(router_conn:, intent_type:)
    cookie_name  = get_cookie_name(intent_type: intent_type)[1][:cookie_name]
    intent_value = router_conn.request[:http][:cookies].dig(cookie_name.to_sym, :value)

    [:ok, intent_value: intent_value]
  end

  # Clear the cookie for :intent_type
  def self.clear_cookie(router_conn:, intent_type:)
    cookie_name = get_cookie_name(intent_type: intent_type)[1][:cookie_name]
    router_conn.response[:http][:cookies][cookie_name] = { value: nil, encrypted: true, delete: true }

    [:ok, router_conn: router_conn]
  end

  # Generate the cookie name for a given :intent_type
  def self.get_cookie_name(intent_type:)
    [:ok, cookie_name: "intent_#{ intent_type }"]
  end

end
