module Kit::Auth::Endpoints::Mailers::Users::SignUp

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Endpoints::Mailers::Users::SignUp.method(:process),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|mailers|users|sign_up',
    target:  self.method(:endpoint),
    aliases: ['mailers|users|sign_up'],
  )

  def self.process(router_conn:, component: nil)
    component ||= Kit::Auth::Components::Emails::Users::SignUpComponent

    user   = router_conn.request[:params][:user]
    params = {
      user: user,
    }

    component_instance = component.new(**params)
    content            = component_instance.local_render(router_conn: router_conn)

    router_conn[:response].deep_merge!({
      content: content,
      mailer:  {
        headers: {
          to:      user.email,
          from:    (I18n.t!('kit.auth.emails.sign_up.from') rescue I18n.t('kit.auth.emails.from')), # rubocop:disable Style/RescueModifier
          subject: I18n.t('kit.auth.emails.sign_up.subject', user: user),
        },
      },
    })

    [:ok, router_conn: router_conn]
  end

end
