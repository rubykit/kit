module Kit::Auth::Controllers::Concerns
  module CurrentUser
    extend ActiveSupport::Concern

    included do
      before_action :resolve_current_user

      helper_method :current_user
    end

    def resolve_current_user
      status, ctx = Kit::Auth::Actions::Users::IdentifyUserForRequest.call({
        request: request,
        cookies: cookies,
      })

      if status == :ok
        request[:current_user] = ctx[:user]
      end
    #rescue Exception
      #binding.pry
    end

    def current_user
      request[:current_user]
    end
  end
end
