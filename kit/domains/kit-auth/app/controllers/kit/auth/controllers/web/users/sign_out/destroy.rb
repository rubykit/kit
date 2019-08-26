module Kit::Auth::Controllers::Web::Users::SignOut
  module Destroy

    def self.endpoint(request:)
      list = [
        :require_current_user!,
        self.method(:sign_out),
      ]

      Kit::Organizer.call({
        list: list,
        ctx: { request: request, },
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|authorization_tokens|destroy',
      aliases: [
        'web|authorization_tokens|destroy',
        'web|users|sign_out',
      ],
      target:  self.method(:endpoint),
    })

    def self.sign_out(request:)
      access_token = request.metadata[:current_user_oauth_access_token]
      if access_token
        Kit::Auth::Services::OauthAccessToken.revoke({ oauth_access_token: access_token })

        request.http.cookies[:access_token] = { value: nil, encrypted: true }
      end

      Kit::Router::Controllers::Http.redirect_to(
        location: Kit::Router::Services::Router.path(id: 'web|users|sign_in')
      )
    end

  end
end