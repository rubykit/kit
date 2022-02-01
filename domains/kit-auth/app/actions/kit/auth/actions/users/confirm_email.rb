# Given an access_token for Email confirmation.
module Kit::Auth::Actions::Users::ConfirmEmail

  # TODO: add contract on router_conn / cookies (based on needed access)
  #Contract Hash => [Symbol, KeywordArgs[user: Any]]
  def self.call(router_conn:, access_token:)
    status, ctx = Kit::Organizer.call(
      list: [
        self.method(:load_user_email),
        self.method(:ensure_email_not_confirmed),
        Kit::Auth::Actions::Users::EnsureActiveToken,
        [:local_ctx, [:alias, :web_redirect_if_missing_scope!], { scope: Kit::Auth::Services::Scopes::USER_EMAIL_CONFIRMATION }],
        self.method(:confirm_email),
      ],
      ctx:  {
        router_conn:  router_conn,
        access_token: access_token,
      },
    )

    if router_conn.response[:http][:redirect]
      [:halt, ctx]
    else
      [status, ctx]
    end
  end

  def self.load_user_email(access_token:)
    user_email_id = access_token.data['user_email_id']

    [:ok, user_email: Kit::Auth::Models::Write::UserEmail.find(user_email_id)]
  end

  def self.ensure_email_not_confirmed(router_conn:, user_email:)
    if user_email.confirmed?
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home')

      Kit::Domain::Endpoints::Http.redirect_to(
        router_conn: router_conn,
        location:    redirect_url,
        flash:       {
          info: I18n.t('kit.auth.notifications.email_confirmation.errors.already_confirmed'),
        },
      )
    else
      [:ok]
    end
  end

  def self.confirm_email(router_conn:, user_email:, access_token:)
    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Services::AccessToken.method(:revoke),
        Kit::Auth::Services::UserEmail.method(:confirm),
        self.method(:send_event),
      ],
      ctx:  {
        router_conn:  router_conn,
        access_token: access_token,
        user_email:   user_email,
      },
    )

    [status, (status == :error) ? { errors: ctx[:errors] } : {}]
  end

  def self.send_event(user_email:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|users|auth|email_confirmation|confirmed',
      adapter_name: :async,
      params:       {
        user_email_id: user_email.id,
      },
    )

    [:ok]
  end

end
