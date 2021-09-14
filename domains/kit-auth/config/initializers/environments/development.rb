Rails.application.reloader.to_prepare do

  # Set the `async` adapter to `inline` in dev mode
  store = Kit::Router::Services::Adapters.default_adapter_store
  store[:async] = store[:inline]

end
