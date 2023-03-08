module Kit::Auth::Endpoints::Mailers::Users::PasswordResetLink

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_email_id: Ct::NotNil, access_token_plaintext_secret: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        self.method(:load_user_email!),
        self.method(:set_headers),
        self.method(:set_component),
        self.method(:set_component_params),
        self.method(:set_i18n_params),
        Kit::Domain::Endpoints::Mailer.method(:render),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|mailers|users|password_reset_link',
      target:  self.method(:endpoint),
      aliases: ['mailers|users|password_reset_link'],
    )
  end

  def self.load_user_email!(router_conn:)
    user_email_id = router_conn.request[:params][:user_email_id]
    user_email    = Kit::Auth::Models::Read::UserEmail.find_by!(id: user_email_id)

    [:ok, user_email: user_email]
  end

  # Set emails headers fields
  def self.set_headers(router_conn:, user_email:, i18n_params: nil)
    [:ok, headers: {
      to:      user_email.email,
      #from:    router_conn.config.dig(:kt, :auth, :emails, :password_reset_link, :from),
      from:    (I18n.t!('kit.auth.emails.password_reset.from') rescue I18n.t('kit.auth.emails.from')), # rubocop:disable Style/RescueModifier
      subject: I18n.t('kit.auth.emails.password_reset_link.subject', **(i18n_params || {})),
    },]
  end

  # Set the component Email component that will be rendered
  def self.set_component
    [:ok, component: Kit::Auth::Components::Emails::Users::PasswordResetLinkComponent]
  end

  # Set the parameters that will be made available to the component
  def self.set_component_params(router_conn:, user_email:)
    [:ok, component_params: {
      user_email:                    user_email,
      access_token_plaintext_secret: router_conn.request[:params][:access_token_plaintext_secret],
    },]
  end

  # Set parameters that might be needed for i18n string interpolation.
  def self.set_i18n_params(user_email:)
    [:ok, i18n_params: {
      user_email: user_email,
    },]
  end

end
