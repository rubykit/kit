module Kit::Auth::Endpoints::Events::Users::EmailConfirmationRequest

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_email_id: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Applications::LoadWeb,
        self.method(:load_from_params),
        self.method(:load_user_email!),
        ->(user_email:)  { [:ok, user: user_email.user] },
        Kit::Auth::Actions::AccessTokens::CreateForEmailConfirmation,
        self.method(:notify_user),
        self.method(:persist_event),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|event|users|auth|email_confirmation|request',
      target:  self.method(:endpoint),
      aliases: ['event|users|auth|email_confirmation|request'],
    )
  end

  def self.load_from_params(router_conn:)
    params = router_conn.request[:params]

    [:ok, {
      user_email_id: params[:user_email_id],
      emitted_at:    params[:emitted_at],
    },]
  end

  def self.load_user_email!(user_email_id:)
    user_email = Kit::Auth::Models::Read::UserEmail.find_by!(id: user_email_id)

    [:ok, user_email: user_email]
  end

  def self.notify_user(user_email:, access_token_plaintext_secret:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'mailers|users|email_confirmation_link',
      adapter_name: :mailer,
      params:       {
        user_email_id:                 user_email.id,
        access_token_plaintext_secret: access_token_plaintext_secret,
      },
    )

    [:ok]
  end

  def self.persist_event(user_email:, emitted_at: nil)
    Kit::Domain::Services::Event.persist_event(
      name:       'users|auth|email_confirmation|request',
      data:       {
        user_id:       user_email.user_id,
        user_email_id: user_email.id,
        email:         user_email.email,
      },
      emitted_at: emitted_at,
    )
  end

end
