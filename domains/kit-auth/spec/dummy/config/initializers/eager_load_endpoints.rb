Rails.application.config.to_prepare do
  Kit::Auth::DummyApp::Endpoints.register_endpoints
end
