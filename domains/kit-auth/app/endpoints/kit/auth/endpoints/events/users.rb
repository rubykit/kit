# All Events endpoints related to Users.
module Kit::Auth::Endpoints::Events::Users

  def self.register_endpoints
    Kit::Auth::Endpoints::Events::Users::Oauth::Link.register_endpoint
    Kit::Auth::Endpoints::Events::Users::Oauth::Unlink.register_endpoint

    Kit::Auth::Endpoints::Events::Users::AccessTokenRevoked.register_endpoint

    Kit::Auth::Endpoints::Events::Users::EmailConfirmationRequest.register_endpoint

    Kit::Auth::Endpoints::Events::Users::EmailConfirmed.register_endpoint

    Kit::Auth::Endpoints::Events::Users::PasswordReset.register_endpoint

    Kit::Auth::Endpoints::Events::Users::PasswordResetRequest.register_endpoint

    Kit::Auth::Endpoints::Events::Users::SignIn.register_endpoint

    Kit::Auth::Endpoints::Events::Users::SignInLinkRequest.register_endpoint

    Kit::Auth::Endpoints::Events::Users::SignOut.register_endpoint

    Kit::Auth::Endpoints::Events::Users::SignUp.register_endpoint
  end

end
