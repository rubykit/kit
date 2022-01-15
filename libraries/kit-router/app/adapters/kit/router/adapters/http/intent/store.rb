module Kit::Router::Adapters::Http::Intent::Store

  def self.create_intent_store
    {
      steps: [
        :user_sign_in,
        :user_sign_up,
      ],
      types: {},
    }
  end

  def self.default_intent_store
    @default_intent_store ||= create_intent_store
  end

end
