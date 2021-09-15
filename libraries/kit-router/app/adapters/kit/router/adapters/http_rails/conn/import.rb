# Import Rails request to Conn.
#
# ### References
# - https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/http/headers.rb
# - https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/http/request.rb
#
module Kit::Router::Adapters::HttpRails::Conn::Import

  def self.import_request(rails_request:, rails_cookies:, rails_controller:)
    if (router_conn = rails_request.instance_variable_get(:@kit_router_conn))
      return [:ok, router_conn: router_conn]
    end

    _, cookies_ctx = import_rails_cookies(rails_cookies: rails_cookies)
    csrf_token     = rails_controller.session[:_csrf_token] ||= SecureRandom.base64(32)

    kit_router_target = rails_request.params[:kit_router_target] || {}

    headers = rails_request
      .headers
      .to_h
      .select { |k, _v| !k.starts_with?('action_') && !k.starts_with?('puma') && !k.starts_with?('rack') }

    headers = ActiveSupport::HashWithIndifferentAccess.new(headers)

    router_conn = Kit::Router::Models::Conn.new(
      adapter:   :http_rails,

      route_id:  kit_router_target[:route_id],
      endpoint:  {
        id:       kit_router_target[:endpoint_id],
        callable: kit_router_target[:endpoint_callable],
      },

      client_ip: rails_request.ip,

      request:   {
        params: rails_request.params.to_h.symbolize_keys,

        http:   {
          cookies:    cookies_ctx[:cookies],
          headers:    headers,
          user_agent: rails_request.user_agent,
          csrf_token: csrf_token,
        },

      },

      response:  {
        content: nil,

        http:    {
          cookies: cookies_ctx[:cookies],
        },
      },

      metadata:  {
        adapters: {
          http_rails: {
            rails_controller: rails_controller,
            rails_request:    rails_request,
          },
        },
      },
    )

    # For Rails helpers
    rails_request.instance_variable_set(:@kit_router_conn, router_conn)

    [:ok, router_conn: router_conn]
  end

  # REF: https://api.rubyonrails.org/v5.2.1/classes/ActionDispatch/Cookies.html
  def self.import_rails_cookies(rails_cookies:)
    result = {}

    rails_cookies.each do |k, v|
      k = k.to_s

      if k.start_with?(Kit::Router::Adapters::HttpRails::Conn.cookies_encrypted_prefix)
        name = k.gsub(%r{^#{ Kit::Router::Adapters::HttpRails::Conn.cookies_encrypted_prefix.gsub('|', '\|') }}, '')
        result[name.to_sym] = {
          name:      name,
          raw_name:  k,
          value:     rails_cookies.encrypted[k],
          raw_value: rails_cookies[k],
        }
      elsif k.start_with?(Kit::Router::Adapters::HttpRails::Conn.cookies_signed_prefix)
        name = k.gsub(%r{^#{ Kit::Router::Adapters::HttpRails::Conn.cookies_signed_prefix.gsub('|', '\|') }}, '')
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
