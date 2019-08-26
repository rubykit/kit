module Kit::Router::Services::Request::Rails
  module Import

    # NOTE: very much a WIP!

    def self.import_request(rails_request:, rails_cookies:, rails_controller:)
      if (request = rails_request.instance_variable_get(:@kit_request))
        return [:ok, request: request]
      end

      _, cookies_ctx = import_rails_cookies(rails_cookies: rails_cookies)
      csrf_token     = rails_controller.session[:_csrf_token] ||= SecureRandom.base64(32)

      request = Kit::Router::Models::Request.new({
        params: rails_request.params.to_h.symbolize_keys,
        root:   rails_request,
        ip:     rails_request.ip,
        http: {
          csrf_token: csrf_token,
          cookies:    cookies_ctx[:cookies],
          headers:    rails_request.headers,
          user_agent: rails_request.user_agent,
        },
      })

      # For Rails helpers
      rails_request.instance_variable_set(:@kit_request, request)

      [:ok, request: request]
    end

    # REF: https://api.rubyonrails.org/v5.2.1/classes/ActionDispatch/Cookies.html
    def self.import_rails_cookies(rails_cookies:)
      result = {}

      rails_cookies.each do |k, v|
        k = k.to_s

        if k.start_with?(Kit::Router::Services::Request::Rails.cookies_encrypted_prefix)
          name = k.gsub(/^#{Kit::Router::Services::Request::Rails.cookies_encrypted_prefix.gsub('|', '\|')}/, '')
          result[name.to_sym] = {
            name:      name,
            raw_name:  k,
            value:     rails_cookies.encrypted[k],
            raw_value: rails_cookies[k],
          }
        elsif k.start_with?(Kit::Router::Services::Request::Rails.cookies_signed_prefix)
          name = k.gsub(/^#{Kit::Router::Services::Request::Rails.cookies_signed_prefix.gsub('|', '\|')}/, '')
          result[name.to_sym] = {
            name:      name,
            raw_name:  k,
            value:     rails_cookies.signed[k],
            raw_value: rails_cookies[k],
          }
        else
          name = k.to_sym
          if !result[name]
            result[name] = {
              name:      k,
              raw_name:  k,
              raw_value: v,
              value:     v,
            }
          end
        end
      end

      [:ok, cookies: result]
    end

  end
end