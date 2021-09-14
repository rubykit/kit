module Kit::Auth::Endpoints::Mailers::Users::SignInLink

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Endpoints::Mailers::Users::SignInLink.method(:process),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|mailers|users|sign_in_link',
    target:  self.method(:endpoint),
    aliases: ['mailers|users|sign_in_link'],
  )

  def self.process(router_request:, component: nil)
    component ||= Kit::Auth::Components::Emails::Users::SignInLinkComponent

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
        subject: I18n.t('kit.auth.emails.sign_in_link.subject', user: user),
        content: content,
      },
    },]
  end

end
