module Kit::Auth::Controllers::Web
  class SignupController < Kit::Auth::Controllers::WebController

    def new
    end

    def create
      safe_params = params.slice(:email, :password, :password_confirmation)

      res, ctx = Kit::Auth::Actions::Users::CreateUserWithPassword(safe_params)

      if res == :ok
      end
    end

  end
end