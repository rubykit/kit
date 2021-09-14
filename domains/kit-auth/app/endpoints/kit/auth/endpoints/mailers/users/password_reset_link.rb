module Kit::Auth::Endpoints::Mailers::Users::PasswordResetLink

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Endpoints::Mailers::Users::PasswordResetLink.method(:process),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|mailers|users|password_reset_link',
    target:  self.method(:endpoint),
    aliases: ['mailers|users|password_reset_link'],
  )

  def self.process(router_request:, component: nil)
    component ||= Kit::Auth::Components::Emails::Users::PasswordResetLinkComponent

    user   = router_request.params[:user]
    params = {
      user:         user,
      access_token: router_request.params[:access_token],
    }

    component_instance = component.new(**params)
    content            = component_instance.local_render(router_request: router_request)

    [:ok, {
      router_response: {
        mime:    :html,
        to:      user.email,
        subject: I18n.t('kit.auth.emails.password_reset_link.subject', user: user),
        content: content,
      },
    },]
  end

end
