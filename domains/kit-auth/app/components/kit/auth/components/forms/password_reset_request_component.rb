# Form view component for reset password requests.
class Kit::Auth::Components::Forms::PasswordResetRequestComponent < Kit::ViewComponents::Components::FormComponent

  def initialize(form_action: nil, form_method: nil, **)
    super

    default_route_id = 'web|users|password_reset|request|create'
    @form_action = form_action || router_path(id: default_route_id)
    @form_method = form_method || router_verb(id: default_route_id)
  end

  def fields_name
    [:email]
  end

end
