module Kit::Auth::Controllers::Web
  module CurrentUser

    def self.require_current_user!(request:)
      return [:ok] if request.metadata[:current_user]

      Kit::Router::Controllers::Http.redirect_to({
        location: Kit::Router::Services::Router.path(id: 'web|users|sign_in'),
      })
    end

    Kit::Organizer.register(id: :require_current_user!, target: self.method(:require_current_user!))


    def self.redirect_if_current_user!(request:)
      return [:ok] if !request.metadata[:current_user]

      Kit::Router::Controllers::Http.redirect_to({
        location: Kit::Router::Services::Router.path(id: 'web|users|after_sign_in'),
      })
    end

    Kit::Organizer.register(id: :redirect_if_current_user!, target: self.method(:redirect_if_current_user!))


    def self.redirect_if_missing_scope!(request:, scope:)
      model = request.metadata[:current_user_oauth_access_token]
      if model
        model_scopes = OAuth::Scopes.from_string(model.scopes)
        return [:ok] if model.scopes.includes?(scope)
      end

      Kit::Router::Controllers::Http.redirect_to({
        location: Kit::Router::Services::Router.path(id: 'web|users|sign_in'),
      })
    end

    Kit::Organizer.register(id: :redirect_if_missing_scope!, target: self.method(:redirect_if_missing_scope!))


    def self.resolve_current_user(request:)
      status, ctx = Kit::Organizer.call({
        list: [
          Kit::Auth::Actions::OauthApplications::LoadWeb,
          Kit::Auth::Actions::Users::IdentifyUserForRequest,
        ],
        ctx: {
          request: request,
        },
        #expose: { ok: { current_user: :user, current_user_oauth_access_token: :oauth_access_token }}
      })

      if status == :ok
        request.metadata[:current_user]                    = ctx[:user]
        request.metadata[:current_user_oauth_access_token] = ctx[:oauth_access_token]
      end

      [:ok, current_user: ctx[:user], current_user_oauth_access_token: ctx[:oauth_access_token]]
    end

    Kit::Organizer.register(id: :resolve_current_user, target: self.method(:resolve_current_user))


  end
end