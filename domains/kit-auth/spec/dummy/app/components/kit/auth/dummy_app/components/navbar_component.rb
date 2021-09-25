class Kit::Auth::DummyApp::Components::NavbarComponent < Kit::ViewComponents::Components::BaseComponent

  attr_reader :current_user

  def initialize(current_user:, current_user_id_type:, **)
    super

    if current_user_id_type == :cookie
      @current_user = current_user
    end
  end

end
