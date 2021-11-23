module Kit::Auth::Endpoints::Events::Users::SignIn

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_id: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        ->(router_conn:) { [:ok, user_id: router_conn.request[:params][:user_id]] },
        self.method(:persist_event),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|user|auth|sign_in',
    target:  self.method(:endpoint),
    aliases: ['event|user|auth|sign_in'],
  )

  def self.persist_event(user_id:)
    Kit::Events::Services::Event.create_event(
      name: 'user|auth|sign_up',
      data: {
        user_id: user_id,
      },
    )
  end

end
