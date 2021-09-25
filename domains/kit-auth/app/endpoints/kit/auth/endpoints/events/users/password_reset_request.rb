module Kit::Auth::Endpoints::Events::Users::PasswordResetRequest

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:if, Kit::Auth::Services::User.method(:find_by_email), {
          ok:    [
            Kit::Auth::Actions::OauthApplications::LoadWeb,
            Kit::Auth::Actions::OauthAccessTokens::CreateForPasswordReset,
            self.method(:notify_user),
            self.method(:persist_event_success),
          ],
          error: [
            self.method(:persist_event_failure),
          ],
        },],
      ],
      ctx:  {
        email:            router_conn.request[:params][:email],
        request_metadata: router_conn.request[:params][:request_metadata],
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|password_reset_request',
    aliases: ['event|users|password_reset_request'],
    target:  self.method(:endpoint),
  )

  def self.notify_user(user:, oauth_access_token_plaintext_secret:)
    Kit::Router::Services::Adapters.call(
      route_id:     'mailers|users|password_reset_link',
      adapter_name: :mailer,
      params:       {
        user:         user,
        access_token: oauth_access_token_plaintext_secret,
      },
    )

    [:ok]
  end

  def self.persist_event_success(user:, oauth_access_token:)
    Kit::Events::Services::Event.create_event(
      name: 'users|password_reset_request|success',
      data: {
        user_id:               user.id,
        oauth_access_token_id: oauth_access_token.id,
      },
    )
  end

  def self.persist_event_failure(email:, request_metadata:)
    Kit::Events::Services::Event.create_event(
      name: 'users|password_reset_request|failure',
      data: {
        email:               email,
        request_metadata_id: request_metadata.id,
      },
    )
  end

end
