module Kit::Auth::Actions::Users::IdentifyUser

  # TODO: add contract on router_conn / cookies (based on needed access)
  #Contract Hash => [Symbol, KeywordArgs[user: Any]]
  def self.call(router_conn:, application:)

    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Services::AccessToken.method(:extract_access_token_paintext_secret),
        Kit::Auth::Services::AccessToken.method(:find_access_token_model),
      ],
      ctx:  {
        router_conn: router_conn,
        application: application,
      },
    )

    if status == :error
      [:error, ctx.slice(:errors)]
    else
      [:ok,    ctx.slice(:user, :access_token, :access_token_type)]
    end
  end

end
