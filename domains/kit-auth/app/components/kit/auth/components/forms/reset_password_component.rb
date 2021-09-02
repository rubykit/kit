class Kit::Auth::Components::Forms::ResetPasswordComponent < Kit::ViewComponents::Components::FormComponent

  def initialize(auth_token_secret:, form_action: nil, form_method: nil, **)
    super

    default_route_id = 'web|users|reset_password_request|create'
    @form_action = form_action || router_path(id: default_route_id)
    @form_method = form_method || router_verb(id: default_route_id)

    @auth_token_secret = auth_token_secret
  end

  def fields_name
    [:password, :password_confirmation]
  end

end
