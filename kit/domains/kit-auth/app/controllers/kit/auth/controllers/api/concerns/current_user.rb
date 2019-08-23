module Kit::Auth::Controllers::Api::Concerns
  module CurrentUser
    extend ActiveSupport::Concern

    included do
      before_action :resolve_current_user

      #helper_method :current_user
      #helper_method :current_user_oauth_access_token
    end

    def resolve_current_user
      return current_user if current_user

      oauth_application = Kit::Auth::Models::Read::OauthApplication.find_by!(uid: 'api')

      status, ctx = Kit::Auth::Actions::Users::IdentifyUserForRequest.call({
        request:           request,
        oauth_application: oauth_application,
      })

      if status == :ok
        # NOTE: `request[:current_user]` adds the value to request.params, so it's a no go
        request.instance_variable_set(:@current_user,                    ctx[:user])
        request.instance_variable_set(:@current_user_oauth_access_token, ctx[:oauth_access_token])
      end
    #rescue Exception
      #binding.pry
    end

    def current_user
      request.instance_variable_get(:@current_user)
    end

    def current_user_oauth_access_token
      request.instance_variable_get(:@current_user_oauth_access_token)
    end

  end
end
