Rails.application.config.to_prepare do
  Kit::Auth::Endpoints.register_endpoints
end
