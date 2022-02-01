module Kit::Auth::Endpoints::Events::Users::SignUp

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_id: Ct::NotNil, sign_up_method: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      safe: true,
      list: [
        self.method(:load_user!),
        self.method(:persist_event),
        #self.method(:notify_user_welcome),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|auth|sign_up',
    target:  self.method(:endpoint),
    aliases: ['event|users|auth|sign_up'],
  )

  def self.load_user!(router_conn:)
    user_id = router_conn.request[:params][:user_id]
    user    = Kit::Auth::Models::Read::User.find_by!(id: user_id)

    [:ok, user: user]
  end

  def self.notify_user_welcome(user:)
    user_email = user.primary_user_email

    Kit::Router::Services::Adapters.cast(
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
      route_id:     'event|users|auth|email_confirmation|request',
      adapter_name: :async,
      params:       {
        user_email_id: user_email.id,
      },
    )

    [:ok]
  end

  def self.persist_event(router_conn:, user:)
    Kit::Events::Services::Event.persist_event(
      name: 'users|auth|sign_up',
      data: {
        user_id: user.id,
        method:  router_conn.request[:params][:sign_up_method],
      },
    )

    [:ok]
  end

end
