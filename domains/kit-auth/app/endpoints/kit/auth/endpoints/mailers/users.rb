# All Mailers endpoints related to Users.
module Kit::Auth::Endpoints::Mailers::Users

  def self.register_endpoints
    Kit::Auth::Endpoints::Mailers::Users::EmailConfirmationLink.register_endpoint
    Kit::Auth::Endpoints::Mailers::Users::PasswordResetLink.register_endpoint
    Kit::Auth::Endpoints::Mailers::Users::SignInLink.register_endpoint
    Kit::Auth::Endpoints::Mailers::Users::SignUp.register_endpoint
  end

end
