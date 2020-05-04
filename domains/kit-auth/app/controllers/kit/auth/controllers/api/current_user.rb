module Kit::Auth::Controllers::Api
  module CurrentUser

    METADATA_KEY_CURRENT_USER                    = :api_current_user
    METADATA_KEY_CURRENT_USER_OAUTH_ACCESS_TOKEN = :api_current_user_oauth_access_token
    METADATA_KEY_CURRENT_USER_ATTEMPTED_RESOLVED = :api_current_user_attempted_resolved

    def self.current_user(request:)
      request.metadata[METADATA_KEY_CURRENT_USER]
    end

    def self.current_user_oauth_access_token(request:)
      request.metadata[METADATA_KEY_CURRENT_USER_OAUTH_ACCESS_TOKEN]
    end

    def self.requires_current_user!(request:)
      _, ctx = api_resolve_current_user(request: request)

      if (model = current_user(request: request))
        return [:ok, current_user: model]
      end

      Kit::Auth::Controllers::Api.render_unauthorized
    end

    Kit::Organizer.register(id: :api_requires_current_user!, target: self.method(:requires_current_user!))


    def self.requires_scope!(request:, scope:)
      _, ctx = api_resolve_current_user(request: request)

      if (model = current_user_oauth_access_token(request: request))
        model_scopes = OAuth::Scopes.from_string(model.scopes)
        return [:ok] if model_scopes.includes?(scope)
      end

      Kit::Auth::Controllers::Api.render_forbidden
    end

    Kit::Organizer.register(id: :api_requires_scope!, target: self.method(:requires_scope!))


    def self.resolve_current_user(request:)
      if !request.metadata[METADATA_KEY_CURRENT_USER_ATTEMPTED_RESOLVED]
        status, ctx = Kit::Organizer.call({
          list: [
            Kit::Auth::Actions::OauthApplications::LoadApi,
            ->(request:, oauth_application:) do
              Kit::Auth::Actions::Users::IdentifyUserForRequest.call(
                request:           request,
                oauth_application: oauth_application,
                allow:             [:param, :header],
              )
            end,
          ],
          ctx: {
            request: request,
          },
        })

        request.metadata[METADATA_KEY_CURRENT_USER_ATTEMPTED_RESOLVED]   = true

        if status == :ok
          request.metadata[METADATA_KEY_CURRENT_USER]                    = ctx[:user]
          request.metadata[METADATA_KEY_CURRENT_USER_OAUTH_ACCESS_TOKEN] = ctx[:oauth_access_token]
        end
      end

      [:ok,
        current_user:                    current_user(request: request),
        current_user_oauth_access_token: current_user_oauth_access_token(request: request),
      ]
    end

    Kit::Organizer.register(id: :api_resolve_current_user, target: self.method(:resolve_current_user))


  end
end