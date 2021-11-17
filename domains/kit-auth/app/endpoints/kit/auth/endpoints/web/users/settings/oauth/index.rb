module Kit::Auth::Endpoints::Web::Users::Settings::Oauth::Index

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_require_session_user!],
        self.method(:list),
        self.method(:render),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|settings|oauth|index',
    aliases: {
      'web|settings|oauth|index': {
        'web|settings|oauth' => [
          # OAuth
          'web|users|oauth|sign_in|after_with_new_identity',
          'web|users|oauth|new_identity',
          'web|users|oauth|error|already_linked',
          'web|users|oauth|error|users_oauth_identity_conflict',
          'web|users|oauth|error|users_conflict',
        ],
      },
    },
    target:  self.method(:endpoint),
  )

  def self.list(router_conn:)
    list = Kit::Auth::Models::Read::UserOauthIdentity
      .where(user_id: router_conn.metadata[:session_user].id)
      .load

    [:ok, list: list]
  end

  def self.render(router_conn:, list:)
    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:   Kit::Auth::Components::Pages::Users::Settings::Oauth::IndexComponent,
      params:      {
        list: list,
      },
    )
  end

end
