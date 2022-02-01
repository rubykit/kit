module Kit::Auth::Endpoints::Events::Users::SignInLinkRequest

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[email: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:    [
        Kit::Auth::Services::UserEmail.method(:find_by_email),
        ->(request_metadata_id:) { [:ok, request_metadata: Kit::Auth::Models::Read::RequestMetadata.find_by(id: request_metadata_id)] },
        Kit::Auth::Actions::Applications::LoadWeb,
        ->(user_email:) { [:ok, user: user_email.user] },
        Kit::Auth::Actions::AccessTokens::CreateForMagicLink,
        self.method(:notify_user),
        self.method(:persist_event_success),
      ],
      error: [
        self.method(:persist_event_failure),
      ],
      ctx:   {
        email:               router_conn.request[:params][:email],
        request_metadata_id: router_conn.request[:params][:request_metadata_id],
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|auth|sign_in|link|request',
    aliases: ['event|users|auth|sign_in|link|request'],
    target:  self.method(:endpoint),
  )

  def self.notify_user(user_email:, access_token_plaintext_secret:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'mailers|users|sign_in_link',
      adapter_name: :mailer,
      params:       {
        user_email_id:                 user_email.id,
        access_token_plaintext_secret: access_token_plaintext_secret,
      },
    )

    [:ok]
  end

  def self.persist_event_success(user_email:, access_token:, email:, request_metadata:)
    Kit::Events::Services::Event.persist_event(
      name: 'users|auth|sign_in|link|request|success',
      data: {
        email:               email,
        request_metadata_id: request_metadata.id,
        user_id:             user_email.user_id,
        user_email_id:       user_email.id,
        access_token_id:     access_token.id,
      },
    )
  end

  def self.persist_event_failure(email:, request_metadata:)
    Kit::Events::Services::Event.persist_event(
      name: 'users|auth|sign_in|link|request|failure',
      data: {
        email:               email,
        request_metadata_id: request_metadata.id,
      },
    )
  end

end
