module Kit::Router::Services::Adapters

  # Resolve the adapter aliased to `adapter_name` & the target endpoint, then forward the call to the target adapter.
  def self.call(endpoint_id:, adapter_name:, params: nil, router_store: nil, adapter_store: nil)
    adapter_call(
      endpoint_id:                endpoint_id,
      adapter_name:               adapter_name,
      params:                     params,
      adapter_target_method_name: :call,
      adapter_store:              adapter_store,
      router_store:               router_store,
    )
  end

  # Resolve the adapter aliased to `adapter_name` and forward the call.
  def self.cast(endpoint_id:, adapter_name:, params: nil, router_store: nil, adapter_store: nil)
    adapter_call(
      endpoint_id:                endpoint_id,
      adapter_name:               adapter_name,
      params:                     params,
      adapter_target_method_name: :cast,
      adapter_store:              adapter_store,
      router_store:               router_store,
    )

    [:ok]
  end

  def self.adapter_call(endpoint_id:, adapter_name:, adapter_target_method_name:, params: nil, router_store: nil, adapter_store: nil)
    params        ||= {}
    router_store  ||= Kit::Router::Services::Router.router_store
    adapter_store ||= Kit::Router::Services::Adapters::Store.adapter_store

    status, ctx = Kit::Organizer.call(
      list: [
        ->(endpoint_id:) { Kit::Router::Services::Store::Endpoint.method(:get_endpoint).call(id: endpoint_id) },
        Kit::Router::Services::Adapters::Store.method(:get_adapter),
        Kit::Router::Services::Adapters::Store.method(:get_adapter_target_method),
      ],
      ctx:  {
        endpoint_id:                endpoint_id,
        adapter_name:               adapter_name,
        adapter_target_method_name: adapter_target_method_name,
        adapter_store:              adapter_store,
        router_store:               router_store,
      },
    )

    return [status, ctx] if status == :error

    ctx[:adapter_target_method].call(
      endpoint: ctx[:endpoint_record][:target],
      params:   params,
    )
  end

end
