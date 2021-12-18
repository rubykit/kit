class Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent < Kit::Auth::Components::Pages::PageComponent

  attr_reader :model

  def initialize(model:, **)
    super

    @model = model
  end

  def has_social_providers?
    Kit::Auth::Services::Oauth.providers.select { |el| el[:group] == :web }.count > 0
  end

end
