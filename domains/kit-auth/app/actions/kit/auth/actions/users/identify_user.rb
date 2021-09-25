module Kit::Auth::Actions::Users::IdentifyUser

  # TODO: add contract on router_conn / cookies (based on needed access)
  #Contract Hash => [Symbol, KeywordArgs[user: Any]]
  def self.call(router_conn:, oauth_application:)

    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Services::OauthAccessToken.method(:extract_access_token),
        Kit::Auth::Services::OauthAccessToken.method(:find_oauth_access_token),
      ],
      ctx:  {
        router_conn:       router_conn,
        oauth_application: oauth_application,
      },
    )

    if status == :error
      [:error, ctx.slice(:errors)]
    else
      [:ok,    ctx.slice(:user, :oauth_access_token, :access_token_type)]
    end
  end

end
