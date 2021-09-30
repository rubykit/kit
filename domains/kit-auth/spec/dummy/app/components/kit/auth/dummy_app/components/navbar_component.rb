class Kit::Auth::DummyApp::Components::NavbarComponent < Kit::ViewComponents::Components::BaseComponent

  attr_reader :session_user

  def initialize(session_user:, **)
    super

    @session_user = session_user
  end

end
