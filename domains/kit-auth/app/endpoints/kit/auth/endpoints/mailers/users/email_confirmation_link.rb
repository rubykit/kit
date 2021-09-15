module Kit::Auth::Endpoints::Mailers::Users::EmailConfirmationLink

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Endpoints::Mailers::Users::EmailConfirmationLink.method(:process),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|mailers|users|email_confirmation_link',
    target:  self.method(:endpoint),
    aliases: ['mailers|users|email_confirmation_link'],
  )

  def self.process(router_conn:, component: nil)
    component ||= Kit::Auth::Components::Emails::Users::EmailConfirmationComponent

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
          from:    (I18n.t!('kit.auth.emails.email_confirmation_link.from') rescue I18n.t('kit.auth.emails.from')), # rubocop:disable Style/RescueModifier
          subject: I18n.t('kit.auth.emails.email_confirmation_link.subject', user: user),
        },
      },
    })

    [:ok, router_conn: router_conn]
  end

end
