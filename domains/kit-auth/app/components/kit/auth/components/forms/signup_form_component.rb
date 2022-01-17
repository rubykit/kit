class Kit::Auth::Components::Forms::SignupFormComponent < Kit::ViewComponents::Components::FormComponent

  def initialize(form_action: nil, form_method: nil, **) # rubocop:disable Lint/UselessMethodDefinition
    super

    default_route_id = 'web|users|sign_up|with_password|create'
    @form_action = form_action || router_path(id: default_route_id)
    @form_method = form_method || router_verb(id: default_route_id)
  end

  def fields_name
    [:email, :password, :password_confirmation, :email_confirmation]
  end

end
