Rails.application.config.to_prepare do
  Kit::JsonApiSpec::Endpoints.register_endpoints
end
