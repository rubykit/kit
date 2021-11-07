class Kit::Auth::Components::Users::OauthIdentityComponent < Kit::Auth::Components::Component

  attr_reader :model

  def initialize(model:)
    super
    @model = model
  end

  def provider
    model.provider
  end

end
