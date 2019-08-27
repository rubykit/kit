module Kit::Auth::Controllers::Api
  module CurrentUser

    def self.api_requires_current_user!(request:)
      if (current_user = request.metadata[:current_user])
        return [:ok, current_user: current_user]
      end

      Kit::Auth::Controllers::ApiController.render_unauthorized
    end

    Kit::Organizer.register(id: :api_requires_current_user!, target: self.method(:api_requires_current_user!))


    def self.api_requires_scope!(request:, scope:)
      model = request.metadata[:current_user_oauth_access_token]
      if model
        model_scopes = OAuth::Scopes.from_string(model.scopes)
        return [:ok] if model.scopes.includes?(scope)
      end

      Kit::Auth::Controllers::ApiController.render_forbidden
    end

    Kit::Organizer.register(id: :api_requires_scope!, target: self.method(:api_requires_scope!))


    def self.api_resolve_current_user(request:)
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

      if status == :ok
        request.metadata[:current_user]                    = ctx[:user]
        request.metadata[:current_user_oauth_access_token] = ctx[:oauth_access_token]
      end

      [:ok, current_user: ctx[:user], current_user_oauth_access_token: ctx[:oauth_access_token]]
    end

    Kit::Organizer.register(id: :api_resolve_current_user, target: self.method(:api_resolve_current_user))


  end
end