module Kit::Auth::Endpoints::Events::Users::AccessTokenRevoked

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_id: Ct::NotNil, user_secret_id: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        self.method(:load_from_params),
        self.method(:persist_event),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|user|auth|access_token|revoked',
    target:  self.method(:endpoint),
    aliases: ['event|user|auth|access_token|revoked'],
  )

  def self.load_from_params(router_conn:)
    params = router_conn.request[:params]

    [:ok, {
      user_id:        params[:user_id],
      user_secret_id: params[:user_secret],
    },]
  end

  def self.persist_event(user_id:, user_secret_id:)
    Kit::Events::Services::Event.create_event(
      name: 'user|auth|access_token|revoked',
      data: {
        user_id:        user_id,
        user_secret_id: user_secret_id,
      },
    )
  end

end
