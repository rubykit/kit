module Kit::Auth::Endpoints::Events::Users::EmailConfirmationRequest

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Applications::LoadWeb,
        self.method(:load_user_email!),
        ->(user_email:) { [:ok, user: Kit::Auth::Models::Read::User.find(user_email.id)] },
        Kit::Auth::Actions::AccessTokens::CreateForEmailConfirmation,
        self.method(:notify_user),
        self.method(:persist_event),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|email_confirmation_request',
    target:  self.method(:endpoint),
    aliases: ['event|users|email_confirmation_request'],
  )

  def self.load_user_email!(router_conn:)
    user_email_id = router_conn.request[:params][:user_email_id]
    user_email    = Kit::Auth::Models::Read::UserEmail.find_by!(id: user_email_id)

    [:ok, user_email: user_email]
  end

  def self.notify_user(user_email:, access_token_plaintext_secret:)
    Kit::Router::Services::Adapters.call(
      route_id:     'mailers|users|email_confirmation_link',
      adapter_name: :mailer,
      params:       {
        user_email_id:                 user_email.id,
        access_token_plaintext_secret: access_token_plaintext_secret,
      },
    )

    [:ok]
  end

  def self.persist_event(user_email:)
    Kit::Events::Services::Event.create_event(
      name: 'users|email_confirmation_request',
      data: {
        user_id:       user_email.user_id,
        user_email_id: user_email.id,
        email:         user_email.email,
      },
    )
  end

end
