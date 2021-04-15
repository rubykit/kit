class Kit::Auth::DummyApp::Components::NavbarComponent < Kit::Domain::Components::Component

  attr_reader :current_user

  def initialize(current_user:, **)
    super
    @current_user = current_user
  end

end
