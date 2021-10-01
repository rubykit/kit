module Kit::Auth::Endpoints::Events::Users::PasswordReset

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_id: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        ->(router_conn:) { [:ok, user_id: router_conn.request[:params][:user_id]] },
        Kit::Auth::Endpoints::Events::Users::PasswordReset.method(:persist_event),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|password_reset',
    target:  self.method(:endpoint),
    aliases: ['event|users|password_reset'],
  )

  def self.persist_event(user_id:)
    Kit::Events::Services::Event.create_event(
      name: 'users|password_reset',
      data: {
        user_id: user_id,
      },
    )
  end

end
