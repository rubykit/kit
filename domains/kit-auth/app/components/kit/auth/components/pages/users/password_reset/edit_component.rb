class Kit::Auth::Components::Pages::Users::PasswordReset::EditComponent < Kit::Auth::Components::Pages::PageComponent

  attr_reader :model, :access_tokens

  def initialize(model:, access_token:, **)
    super

    @model        = model
    @access_token = access_token
  end

end
