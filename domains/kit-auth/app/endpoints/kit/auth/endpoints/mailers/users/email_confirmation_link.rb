module Kit::Auth::Endpoints::Mailers::Users::EmailConfirmationLink

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Endpoints::Mailers::Users::EmailConfirmationLink.method(:process),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|mailers|users|email_confirmation_link',
    target:  self.method(:endpoint),
    aliases: ['mailers|users|email_confirmation_link'],
  )

  def self.process(router_request:, component: nil)
    component ||= Kit::Auth::Components::Emails::Users::EmailConfirmationComponent

    user   = router_request.params[:user]
    params = {
      user: user,
    }

    component_instance = component.new(**params)
    content            = component_instance.local_render(router_request: router_request)

    [:ok, {
      router_response: {
        mime:    :html,
        to:      user.email,
        subject: I18n.t('kit.auth.emails.email_confirmation_link.subject', user: user),
        content: content,
      },
    },]
  end

end
