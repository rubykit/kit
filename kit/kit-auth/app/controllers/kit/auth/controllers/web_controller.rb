module Kit::Auth::Controllers
  class WebController < ActionController::Base
    protect_from_forgery with: :exception

    def current_user
      if !instance_variable_defined?("@current_user")
        access_token = cookies.encrypted[:access_token]
        if !access_token.blank?
          @current_user = Kit::Auth::Models::Read::OauthAccessToken.find_by(token: access_token)&.user
        else
          @current_user = nil
        end
      end

      @current_user
    end

  end
end
