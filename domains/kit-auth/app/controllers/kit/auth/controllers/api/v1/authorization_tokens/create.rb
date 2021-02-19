module Kit::Auth::Controllers::Api::V1::AuthorizationTokens
  module Create

    ROUTE_ID  = 'api_v1|authorization_tokens|create'
    ROUTE_UID = "kit_auth|#{ ROUTE_ID }"

    def self.endpoint(router_request:)
      params = router_request.params[:authorization_token][:data][:attributes]

      status, ctx = Kit::Organizer.call(
        list: [
          Kit::Domain::Controllers::JsonApi.method(:ensure_media_type),
          ->(email:) { [:ok, user: Kit::Auth::Models::Read::User.find_by(email: email)] },
          Kit::Auth::Actions::Users::VerifyPassword,
          Kit::Auth::Actions::Users::SignInApi,
          self.method(:render),
        ],
        ctx:  {
          router_request: router_request,
          email:          params[:uid],
          password:       params[:secret],
        },
      )

      if status == :ok
        [status, ctx]
      else
        Kit::Router::Controllers::Http.render_jsonapi_errors(
          resources: ctx[:errors],
        )
      end
    end

    Kit::Router::Services::Router.register(
      uid:     ROUTE_UID,
      aliases: {
        ROUTE_ID => 'api|authorization_tokens|create',
      },
      target:  self.method(:endpoint),
    )

    def self.render(oauth_access_token:, oauth_access_token_plaintext_secret:)
      # NOTE: we need a special serializer here that allows us to expose `oauth_access_token_plaintext_secret`
      Kit::Router::Controllers::Http.render_jsonapi(
        status:      201,
        resources:   oauth_access_token,
        serializers: Kit::Auth::Controllers::Api.serializers,
        #links: {
        #  self: Kit::Router::Services::Router.url(id: ROUTE_UID, params: { resource_id: oauth_access_token.id }),
        #},
      )
    end

  end
end
