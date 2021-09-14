module Kit::Auth::Endpoints::Events::Users::SignIn

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        ->(router_request:) { [:ok, user: router_request.params[:user]] },
        Kit::Auth::Endpoints::Events::Users::SignIn.method(:persist_event),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|user|auth|sign_in',
    target:  self.method(:endpoint),
    aliases: ['event|user|auth|sign_in'],
  )

  def self.persist_event(user:)
    Kit::Events::Services::Event.create_event(
      name: 'user|auth|sign_up',
      data: {
        user_id: user.id,
      },
    )
  end

end
