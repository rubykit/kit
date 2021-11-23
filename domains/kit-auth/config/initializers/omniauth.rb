if defined?(OmniAuth)

  OmniAuth::Strategy.class_eval do

    # NOTE: add the provider application id `app_id` to the available data in `env['omniauth.auth']` if available.
    def auth_hash
      credentials_data = credentials
      extra_data = extra
      client_id  = self.respond_to?(:client) ? client.id : nil

      OmniAuth::AuthHash.new(provider: name, uid: uid).tap do |auth|
        auth.info        = info             if !skip_info?
        auth.credentials = credentials_data if credentials_data
        auth.extra       = extra_data       if extra_data
        auth.app_id      = client_id
      end
    end

  end

end
