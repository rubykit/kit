class Kit::Auth::DummyApp::Components::NavbarComponent < Kit::UiComponents::Components::BaseComponent

  attr_reader :current_user

  def initialize(current_user:, **)
    super
    @current_user = current_user
  end

end
