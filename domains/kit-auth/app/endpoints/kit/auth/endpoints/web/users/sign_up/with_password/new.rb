module Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::New

  def self.endpoint(router_conn:, component: nil)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_session_user!],
        [:local_ctx, Kit::Router::Adapters::Http::Intent::Actions::Save, { intent_step: :user_sign_up, intent_type: router_conn.request[:params][:intent] }],
        self.method(:set_form_model),
        self.method(:set_page_component),
        Kit::Domain::Endpoints::Http.method(:render_form_page),
      ],
      ctx:  {
        router_conn: router_conn,
        component:   component,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|new',
    aliases: {
      'web|users|new' => 'web|users|sign_up',
    },
    target:  self.method(:endpoint),
  )

  def self.set_form_model
    form_model = { email: nil, password: nil }

    [:ok, form_model: form_model]
  end

  def self.set_page_component(component: nil)
    [:ok, component: component || Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent]
  end

end
