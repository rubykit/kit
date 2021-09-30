module Kit::Auth::Actions::Users::IdentifyUser

  # TODO: add contract on router_conn / cookies (based on needed access)
  #Contract Hash => [Symbol, KeywordArgs[user: Any]]
  def self.call(router_conn:, application:)

    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Services::AccessTokenRequest.method(:extract_plaintext_secrets_by_field),
        Kit::Auth::Services::AccessTokenRequest.method(:categorize_plaintext_secrets),
        Kit::Auth::Services::AccessTokenRequest.method(:find_access_token_models),
        self.method(:ensure_same_users),
      ],
      ctx:  {
        router_conn: router_conn,
        application: application,
      },
    )

    if status == :error
      [:error, ctx.slice(:errors)]
    else
      [:ok,    ctx.slice(:user, :access_tokens, :access_token_type)]
    end
  end

  def self.ensure_same_users(router_conn:, access_tokens:)
    if access_tokens[:session] && access_tokens[:request] && access_tokens[:session].user_id != access_tokens[:request].user_id
      Kit::Domain::Endpoints::Http.redirect_to(
        router_conn: router_conn,
        location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home'),
        flash:       {
          error: 'Conflicting access tokens.',
        },
      )
    else
      [:ok]
    end
  end

end
