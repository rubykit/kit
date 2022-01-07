# Set the `async` adapter to `inline` if requested.
if ENV['KIT_ROUTER_ASYNC_ADAPTER'] == 'inline'
  store = Kit::Router::Services::Adapters.default_adapter_store
  store[:async] = store[:inline]
end
