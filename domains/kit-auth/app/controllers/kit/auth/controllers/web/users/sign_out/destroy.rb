module Kit::Auth::Controllers::Web::Users::SignOut
  module Destroy

    def self.endpoint(router_request:)
      Kit::Organizer.call({
        list: [
          [:alias, :web_require_current_user!],
          self.method(:sign_out),
        ],
        ctx:  { router_request: router_request },
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|authorization_tokens|destroy',
      aliases: {
        'web|authorization_tokens|destroy': ['web|users|sign_out'],
      },
      target:  self.method(:endpoint),
    })

    def self.sign_out(router_request:)
      access_token = router_request.metadata[:current_user_oauth_access_token]
      if access_token
        Kit::Auth::Services::OauthAccessToken.revoke({ oauth_access_token: access_token })

        router_request.http.cookies[:access_token] = { value: nil, encrypted: true }
      end

      Kit::Router::Controllers::Http.redirect_to(
        location: Kit::Router::Services::Adapters::Http::Mountpoints.path(id: 'web|users|after_sign_out'),
      )
    end

  end
end
