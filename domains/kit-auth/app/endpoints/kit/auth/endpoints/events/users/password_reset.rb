module Kit::Auth::Endpoints::Events::Users::PasswordReset

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        ->(router_request:) { [:ok, user: router_request.params[:user]] },
        Kit::Auth::Endpoints::Events::Users::PasswordReset.method(:persist_event),
      ],
      ctx:  {
        router_request: router_request,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|password_reset',
    target:  self.method(:endpoint),
    aliases: ['event|users|password_reset'],
  )

  def self.persist_event(user:)
    Kit::Events::Services::Event.create_event(
      name: 'users|password_reset',
      data: {
        user_id: user.id,
      },
    )
  end

end