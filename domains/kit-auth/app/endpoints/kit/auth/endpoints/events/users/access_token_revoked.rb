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

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|event|users|auth|access_token|revoked',
      target:  self.method(:endpoint),
      aliases: ['event|users|auth|access_token|revoked'],
    )
  end

  def self.load_from_params(router_conn:)
    params = router_conn.request[:params]

    [:ok, {
      user_id:        params[:user_id],
      user_secret_id: params[:user_secret],
      emitted_at:     params[:emitted_at],
    },]
  end

  def self.persist_event(user_id:, user_secret_id:, emitted_at: nil)
    Kit::Domain::Services::Event.persist_event(
      name:       'users|auth|access_token|revoked',
      data:       {
        user_id:        user_id,
        user_secret_id: user_secret_id,
      },
      emitted_at: emitted_at,
    )
  end

end
