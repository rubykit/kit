module Kit::Auth::Endpoints::Events::Users::SignUp

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      safe: true,
      list: [
        self.method(:load_user!),
        self.method(:persist_event),
        #self.method(:notify_user_welcome),
        self.method(:send_event_email_confirmation_request),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|user|auth|sign_up',
    target:  self.method(:endpoint),
    aliases: ['event|user|auth|sign_up'],
  )

  def self.load_user!(router_conn:)
    user_id = router_conn.request[:params][:user_id]
    user    = Kit::Auth::Models::Read::User.find_by!(id: user_id)

    [:ok, user: user]
  end

  def self.notify_user_welcome(user:)
    user_email = user.primary_user_email

    Kit::Router::Services::Adapters.call(
      route_id:     'mailers|users|sign_up',
      adapter_name: :mailer,
      params:       {
        user_email_id: user_email.id,
      },
    )

    [:ok]
  end

  def self.send_event_email_confirmation_request(user:)
    user_email = user.primary_user_email

    return [:ok] if user_email.confirmed?

    Kit::Router::Services::Adapters.cast(
      route_id:     'event|users|email_confirmation_request',
      adapter_name: :async,
      params:       {
        user_email_id: user_email.id,
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

    [:ok]
  end

end
