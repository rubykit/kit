module Kit::Auth::Controllers
  # NOTE: This is a little backward: we inherit from the engine container controller in order to display the layout
  class WebController < ::WebController
    #include Kit::Auth::Controllers::Web::Concerns::CurrentUser

    protect_from_forgery with: :exception

=begin
    def require_current_user!
      return if current_user

      redirect_to Kit::Router.path(id: 'web|users|sign_in')
    end


    def redirect_if_current_user!
      return if !current_user

      redirect_to Kit::Router.path(id: 'web|users|after_sign_in')
    end

    def redirect_if_missing_scope!(scope:)
      model = current_user_oauth_access_token
      if model
        model_scopes = OAuth::Scopes.from_string(model.scopes)
        return if model.scopes.includes?(scope)
      end

      redirect_to Kit::Router.path(id: 'web|users|sign_in')
    end
=end

  end
end
