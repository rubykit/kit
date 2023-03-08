# All Web endpoints related to Users.
module Kit::Auth::Endpoints::Web::Users

  def self.register_endpoints
    Kit::Auth::Endpoints::Web::Users::ConfirmEmail::Update.register_endpoint

    Kit::Auth::Endpoints::Web::Users::Oauth::Authentify.register_endpoint
    Kit::Auth::Endpoints::Web::Users::Oauth::Callback.register_endpoint

    Kit::Auth::Endpoints::Web::Users::PasswordReset::Edit.register_endpoint
    Kit::Auth::Endpoints::Web::Users::PasswordReset::Update.register_endpoint

    Kit::Auth::Endpoints::Web::Users::PasswordResetRequest::Create.register_endpoint
    Kit::Auth::Endpoints::Web::Users::PasswordResetRequest::New.register_endpoint

    Kit::Auth::Endpoints::Web::Users::Settings::Oauth::Destroy.register_endpoint
    Kit::Auth::Endpoints::Web::Users::Settings::Oauth::Index.register_endpoint

    Kit::Auth::Endpoints::Web::Users::Settings::Sessions::Destroy.register_endpoint
    Kit::Auth::Endpoints::Web::Users::Settings::Sessions::Index.register_endpoint

    Kit::Auth::Endpoints::Web::Users::SignIn::LinkRequest::Create.register_endpoint
    Kit::Auth::Endpoints::Web::Users::SignIn::LinkRequest::New.register_endpoint

    Kit::Auth::Endpoints::Web::Users::SignIn::WithMagicLink::Create.register_endpoint

    Kit::Auth::Endpoints::Web::Users::SignIn::WithOauth::New.register_endpoint

    Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.register_endpoint
    Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::New.register_endpoint

    Kit::Auth::Endpoints::Web::Users::SignOut::Destroy.register_endpoint

    Kit::Auth::Endpoints::Web::Users::SignUp::WithOauth::New.register_endpoint

    Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.register_endpoint
    Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::New.register_endpoint
  end

end
