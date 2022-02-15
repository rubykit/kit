module Kit::Auth::Endpoints::Events::Users::Oauth::Unlink

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_oauth_identity_id: Ct::NotNil, user_id: Ct::NotNil, provider: Ct::NotNil, provider_uid: Ct::NotNil]]]
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
    uid:     'kit_auth|event|users|oauth|unlinked',
    target:  self.method(:endpoint),
    aliases: ['event|users|oauth|unlinked'],
  )

  def self.load_from_params(router_conn:)
    params = router_conn.request[:params]

    [:ok, {
      user_oauth_identity_id: params[:user_oauth_identity_id],
      user_id:                params[:user_id],
      provider:               params[:provider],
      provider_uid:           params[:provider_uid],
      emitted_at:             params[:emitted_at],
    },]
  end

  def self.persist_event(user_id:, user_oauth_identity_id:, provider:, provider_uid:, emitted_at: nil)
    Kit::Domain::Services::Event.persist_event(
      name:       'user|oauth|unlinked',
      data:       {
        user_id:                user_id,
        user_oauth_identity_id: user_oauth_identity_id,
        provider:               provider,
        provider_uid:           provider_uid,
      },
      emitted_at: emitted_at,
    )
  end

end
