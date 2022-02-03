module Kit::Auth::Endpoints::Events::Users::PasswordReset

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_id: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        ->(router_conn:) { [:ok, user_id: router_conn.request[:params][:user_id]] },
        ->(router_conn:) { [:ok, emitted_at: router_conn.request[:params][:emitted_at]] },
        self.method(:persist_event),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|auth|password_reset',
    target:  self.method(:endpoint),
    aliases: ['event|users|auth|password_reset'],
  )

  def self.persist_event(user_id:, emitted_at: nil)
    Kit::Events::Services::Event.persist_event(
      name: 'users|auth|password_reset',
      data: {
        user_id: user_id,
      }.merge(emitted_at ? { emitted_at: emitted_at } : {}),
    )
  end

end
