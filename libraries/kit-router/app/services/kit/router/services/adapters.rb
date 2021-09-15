module Kit::Router::Services::Adapters

  # Resolve the adapter aliased to `adapter_name` & the target endpoint, then forward the call to the target adapter.
  def self.call(route_id:, adapter_name:, params: nil, router_store: nil, adapter_store: nil)
    adapter_call(
      route_id:            route_id,
      adapter_name:        adapter_name,
      params:              params,
      adapter_method_name: :call,
      adapter_store:       adapter_store,
      router_store:        router_store,
    )
  end

  # Resolve the adapter aliased to `adapter_name` and forward the call.
  def self.cast(route_id:, adapter_name:, params: nil, router_store: nil, adapter_store: nil)
    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Router::Services::Store::Endpoint.method(:get_endpoint),
      ],
      ctx:  { id: route_id },
    )

    return [status, ctx] if status == :error

    adapter_call(
      route_id:            route_id,
      adapter_name:        adapter_name,
      params:              params,
      adapter_method_name: :cast,
      adapter_store:       adapter_store,
      router_store:        router_store,
    )

    [:ok]
  end

  def self.create_router_conn(adapter_name:, endpoint_record:, params:, route_id:)
    router_conn = Kit::Router::Models::Conn.new(
      adapter:  adapter_name,
      params:   params,
      route_id: route_id,
      endpoint: {
        uid:      endpoint_record[:uid],
        callable: endpoint_record[:target],
      },
    )

    [:ok, router_conn: router_conn]
  end

  def self.adapter_call(route_id:, adapter_name:, adapter_method_name:, params: nil, router_store: nil, adapter_store: nil)
    params        ||= {}
    router_store  ||= Kit::Router::Services::Router.router_store
    adapter_store ||= Kit::Router::Services::Adapters.default_adapter_store

    status, ctx = Kit::Organizer.call(
      list: [
        ->(route_id:) { Kit::Router::Services::Store::Endpoint.get_endpoint(id: route_id) },
        Kit::Router::Services::Adapters::Store.method(:get_adapter),
        Kit::Router::Services::Adapters::Store.method(:get_adapter_callable),
        self.method(:create_router_conn),
      ],
      ctx:  {
        route_id:            route_id,
        params:              params,
        adapter_name:        adapter_name,
        adapter_method_name: adapter_method_name,
        adapter_store:       adapter_store,
        router_store:        router_store,
      },
    )

    return [status, ctx] if status == :error

    ctx[:adapter_callable].call(router_conn: ctx[:router_conn])
  end

  def self.default_adapter_store
    Kit::Router::Services::Adapters::Store.default_adapter_store
  end

end
