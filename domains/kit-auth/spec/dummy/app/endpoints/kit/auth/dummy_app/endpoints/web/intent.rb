module Kit::Auth::DummyApp::Endpoints::Web::Intent

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:  [
        self.method(:set_page_component),
        Kit::Domain::Endpoints::Http.method(:render_form_page),
      ],
      ctx: { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-auth|spec_app|web|intent',
    aliases: ['web|intent|post_sign_in', 'web|intent|post_sign_up'],
    target:  self.method(:endpoint),
  )

  def self.set_page_component
    [:ok,
      component:  Kit::Auth::DummyApp::Components::Pages::IntentComponent,
      form_model: nil,
    ]
  end

end
