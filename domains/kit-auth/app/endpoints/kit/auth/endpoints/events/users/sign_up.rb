module Kit::Auth::Endpoints::Events::Users::SignUp

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        ->(router_request:) { [:ok, user: router_request.params[:user]] },
        Kit::Auth::Endpoints::Events::Users::SignUp.method(:persist_event),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|user|auth|sign_up',
    target:  self.method(:endpoint),
    aliases: ['event|user|auth|sign_up'],
  )

  def self.notify_user(user:)
    Kit::Router::Services::Adapters.call(
      route_id:     'mailers|users|sign_up',
      adapter_name: :mailer,
      params:       {
        user: user,
      },
    )

    [:ok]
  end

  def self.persist_event(user:)
    Kit::Events::Services::Event.create_event(
      name: 'user|auth|sign_up',
      data: {
        user_id: user.id,
      },
    )
  end

end
