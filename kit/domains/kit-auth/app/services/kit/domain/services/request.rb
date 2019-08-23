require 'ostruct'

module Kit::Domain::Services::Request

  class Request
    attr_reader :params, :root, :http, :metadata, :ip

    def initialize(params:, root: nil, http: nil, metadata: nil, ip: nil, **)
      @params = params
      #@root   = root

      @ip     = ip

      @http   = OpenStruct.new(http || {
        csrf_token: nil,
        cookies:    {},
        headers:    {},
        user_agent: nil,
      })

      @metadata = OpenStruct.new(metadata || {})
    end
  end

  COOKIES_ENCRYPTED_PREFIX = 'enc|'
  COOKIES_SIGNED_PREFIX    = 'sig|'

  class << self

    def create_from_rails_request(rails_request:, rails_cookies:, controller_context:)
      _, cookies_ctx = extract_rails_cookies(rails_cookies: rails_cookies)

      csrf_token = controller_context.session[:_csrf_token] ||= SecureRandom.base64(32)

      request = Request.new({
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
    def extract_rails_cookies(rails_cookies:)
      result = {}

      rails_cookies.each do |k, v|
        k = k.to_s

        if k.start_with?(COOKIES_ENCRYPTED_PREFIX)
          name = k.gsub(/^#{COOKIES_ENCRYPTED_PREFIX.gsub('|', '\|')}/, '')
          result[name.to_sym] = {
            name:      name,
            raw_name:  k,
            value:     rails_cookies.encrypted[k],
            raw_value: rails_cookies[k],
          }
        elsif k.start_with?(COOKIES_SIGNED_PREFIX)
          name = k.gsub(/^#{COOKIES_SIGNED_PREFIX.gsub('|', '\|')}/, '')
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

    def export_rails_cookies(rails_cookies:, request_cookies:)
      request_cookies.each do |name, cookie|
        payload = cookie.slice(:value, :expires)
        if cookie[:encrypted] == true
          rails_cookies.encrypted["#{COOKIES_ENCRYPTED_PREFIX}#{name}"] = payload
        elsif cookie[:signed] == true
          rails_cookies.signed["#{COOKIES_SIGNED_PREFIX}#{name}"]       = payload
        else
          rails_cookies[name]                                           = payload
        end
      end

      [:ok]
    end

  end
end