module Kit::Auth::Controllers::Web::Concerns
  module CurrentUser
    extend ActiveSupport::Concern

    included do
      before_action :resolve_current_user

      helper_method :current_user
    end

    def resolve_current_user
      oauth_application = Kit::Auth::Models::Read::OauthApplication.find_by!(uid: 'webapp')

      status, ctx = Kit::Auth::Actions::Users::IdentifyUserForRequest.call({
        cookies:           cookies,
        request:           request,
        oauth_application: oauth_application,
      })

      if status == :ok
        # NOTE: `request[:current_user]` adds the value to request.params, so it's a no go
        request.instance_variable_set(:@current_user, ctx[:user])
      end
    #rescue Exception
      #binding.pry
    end

    def current_user
      #request[:current_user]
      request.instance_variable_get(:@current_user)
    end
  end
end
