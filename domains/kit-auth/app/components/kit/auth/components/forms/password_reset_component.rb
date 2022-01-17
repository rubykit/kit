class Kit::Auth::Components::Forms::PasswordResetComponent < Kit::ViewComponents::Components::FormComponent

  attr_reader :access_token

  def initialize(access_token:, form_action: nil, form_method: nil, **)
    super

    default_route_id = 'web|users|password_reset|request|create'
    @form_action = form_action || router_path(id: default_route_id)
    @form_method = form_method || router_verb(id: default_route_id)

    @access_token = access_token
  end

  def fields_name
    [:password, :password_confirmation]
  end

end
