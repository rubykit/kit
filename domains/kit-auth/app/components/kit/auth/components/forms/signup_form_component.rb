class Kit::Auth::Components::Forms::SignupFormComponent < Kit::Auth::Components::Forms::FormComponent

  attr_reader :route_id

  def initialize(*, route_id: nil, **) # rubocop:disable Lint/UselessMethodDefinition
    super

    @route_id = route_id || 'web|users|create'
  end

  def fields_name
    [:email, :password, :password_confirmation, :email_confirmation]
  end

end
