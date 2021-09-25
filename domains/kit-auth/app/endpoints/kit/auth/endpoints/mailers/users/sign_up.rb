module Kit::Auth::Endpoints::Mailers::Users::SignUp

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        self.method(:set_headers),
        self.method(:set_component),
        self.method(:set_component_params),
        self.method(:set_i18n_params),
        Kit::Domain::Endpoints::Mailer.method(:render),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|mailers|users|sign_up',
    target:  self.method(:endpoint),
    aliases: ['mailers|users|sign_up'],
  )

  # Set emails headers fields
  def self.set_headers(router_conn:, i18n_params: nil)
    [:ok, headers: {
      to:      router_conn.request[:params][:user].email,
      #from:    router_conn.config.dig(:kit, :auth, :emails, :sign_up, :from),
      from:    (I18n.t!('kit.auth.emails.sign_up.from') rescue I18n.t('kit.auth.emails.from')), # rubocop:disable Style/RescueModifier
      subject: I18n.t('kit.auth.emails.sign_up.subject', **(i18n_params || {})),
    },]
  end

  # Set the component Email component that will be rendered
  def self.set_component
    [:ok, component: Kit::Auth::Components::Emails::Users::SignUpComponent]
  end

  # Set the parameters that will be made available to the component
  def self.set_component_params(router_conn:)
    [:ok, component_params: {
      user: router_conn.request[:params][:user],
    },]
  end

  # Set parameters that might be needed for i18n string interpolation.
  def self.set_i18n_params(router_conn:)
    [:ok, i18n_params: {
      user: router_conn.request[:params][:user],
    },]
  end

end
