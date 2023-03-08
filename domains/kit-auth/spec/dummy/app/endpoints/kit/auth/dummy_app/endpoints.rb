module Kit::Auth::DummyApp::Endpoints

  def self.register_endpoints
    Kit::Auth::DummyApp::Endpoints::Web::Home.register_endpoint
    Kit::Auth::DummyApp::Endpoints::Web::RouteAlias.register_endpoint
    Kit::Auth::DummyApp::Endpoints::Web::Settings.register_endpoint
  end

end
