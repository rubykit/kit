module Kit::Router::Adapters::Http::Intent::Store

  def self.create_intent_store
    {}
  end

  def self.default_intent_store
    @default_intent_store ||= create_intent_store
  end

end
