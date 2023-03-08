Rails.application.config.to_prepare do
  Kit::Domain::Endpoints::Specs.register_endpoints
end
