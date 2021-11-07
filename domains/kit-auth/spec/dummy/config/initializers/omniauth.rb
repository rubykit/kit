module OmniAuth::Strategies

  class FacebookWeb < OmniAuth::Strategies::Facebook

    def name
      :facebook_web
    end

  end

end

Rails.application.config.middleware.use OmniAuth::Builder do

  OmniAuth.config.path_prefix = '/web/omniauth'

  provider :facebook_web, ENV['OAUTH_FACEBOOK_APP_ID'], ENV['OAUTH_FACEBOOK_APP_SECRET'], callback_path: '/web/oauth/callback/facebook'

end

Rails.application.reloader.to_prepare do
  Kit::Auth::Services::Oauth.providers << {
    group:             :web,
    external_name:     :facebook,
    internal_name:     :facebook,
    omniauth_strategy: :facebook_web,
  }
end
