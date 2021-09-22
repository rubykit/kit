class Kit::Auth::Components::Pages::Users::PasswordResetRequest::NewComponent < Kit::Auth::Components::Pages::PageComponent

  attr_reader :model

  def initialize(model:, **)
    super

    @model = model
  end

end
