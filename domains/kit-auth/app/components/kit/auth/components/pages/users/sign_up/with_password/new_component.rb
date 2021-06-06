class Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent < Kit::Auth::Components::Pages::PageComponent

  attr_reader :model

  def initialize(model:, **)
    super

    @model = model
  end

end
