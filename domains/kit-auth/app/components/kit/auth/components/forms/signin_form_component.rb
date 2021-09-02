class Kit::Auth::Components::Forms::SigninFormComponent < Kit::UiComponents::Components::FormComponent

  def initialize(form_action: nil, form_method: nil, **) # rubocop:disable Lint/UselessMethodDefinition
    super

    default_route_id = 'web|authorization_tokens|create'
    @form_action = form_action || router_path(id: default_route_id)
    @form_method = form_method || router_verb(id: default_route_id)
  end

  def fields_name
    [:email, :password]
  end

end
