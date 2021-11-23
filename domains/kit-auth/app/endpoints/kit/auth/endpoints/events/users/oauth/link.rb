module Kit::Auth::Endpoints::Events::Users::Oauth::Link

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_oauth_identity_id: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        ->(router_conn:) { [:ok, user_oauth_identity_id: router_conn.request[:params][:user_oauth_identity_id]] },
        self.method(:persist_event),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|user|oauth|linked',
    target:  self.method(:endpoint),
    aliases: ['event|user|oauth|linked'],
  )

  def self.persist_event(user_oauth_identity_id:)
    user_oauth_identity = Kit::Auth::Models::Read::UserOauthIdentity.find_by(id: user_oauth_identity_id)

    Kit::Events::Services::Event.create_event(
      name: 'user|oauth|linked',
      data: {
        user_id:                user_oauth_identity.user_id,
        user_oauth_identity_id: user_oauth_identity.id,
        provider:               user_oauth_identity.provider,
      },
    )
  end

end
