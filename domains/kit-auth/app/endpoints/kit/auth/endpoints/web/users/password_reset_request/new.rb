module Kit::Auth::Endpoints::Web::Users::PasswordResetRequest::New

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:  [
        [:alias, :web_redirect_if_session_user!],
        self.method(:set_form_model),
        self.method(:set_page_component),
        Kit::Domain::Endpoints::Http.method(:render_form_page),
      ],
      ctx: { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|password_reset_request|new',
    aliases: ['web|users|password_reset_request|new'],
    target:  self.method(:endpoint),
  )

  def self.set_form_model(router_conn:)
    form_model = { email: nil }

    [:ok, form_model: form_model]
  end

  def self.set_page_component
    [:ok, component: Kit::Auth::Components::Pages::Users::PasswordResetRequest::NewComponent]
  end

end
