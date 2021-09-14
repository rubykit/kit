class Kit::Auth::Components::Pages::Users::SignIn::WithMagicLink::AfterComponent < Kit::Auth::Components::Pages::PageComponent

  attr_reader :email

  def initialize(email:, **)
    super

    @email = email
  end

end
