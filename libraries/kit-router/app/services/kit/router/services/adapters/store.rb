# Local store to save all adapters
module Kit::Router::Services::Adapters::Store

  def self.register_adapter(adapter_name:, adapter:, adapter_store: nil)
    adapter_store ||= default_adapter_store

    adapter_store[adapter_name] = adapter

    [:ok, adapter_store: adapter_store]
  end

  def self.get_adapter(adapter_name:, adapter_store: nil)
    adapter_store ||= default_adapter_store

    adapter = adapter_store[adapter_name.to_sym]
    if !adapter
      [:error, "Could not find adapter `#{ adapter_name }`"]
    end

    [:ok, adapter: adapter]
  end

  def self.get_adapter_callable(adapter:, adapter_method_name:)
    if !adapter.respond_to?(adapter_method_name)
      [:error, "Adapter `#{ adapter_name }` does not support `#{ adapter_method_name }`"]
    end

    [:ok, adapter_callable: adapter.method(adapter_method_name)]
  end

  def self.default_adapter_store
    @default_adapter_store ||= create_store
  end

  def self.create_store
    {
      inline: Kit::Router::Adapters::InlineBase,
      http:   Kit::Router::Adapters::HttpRails,
      mailer: Kit::Router::Adapters::MailerRails,
      async:  Kit::Router::Adapters::AsyncRails,
    }
  end

end
