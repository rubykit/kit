module Kit::Auth::Endpoints::Events::Users::SignIn

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_id: Ct::NotNil, sign_in_method: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        self.method(:persist_event),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|auth|sign_in',
    target:  self.method(:endpoint),
    aliases: ['event|users|auth|sign_in'],
  )

  def self.persist_event(router_conn:)
    params = router_conn.request[:params]

    Kit::Events::Services::Event.persist_event(
      name: 'users|auth|sign_in',
      data: {
        user_id: params[:user_id],
        method:  params[:sign_in_method],
      },
    )
  end

end
