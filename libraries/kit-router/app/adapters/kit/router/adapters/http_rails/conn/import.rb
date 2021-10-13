# Import Rails request to Conn.
#
# ### References
# - https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/http/headers.rb
# - https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/http/request.rb
#
module Kit::Router::Adapters::HttpRails::Conn::Import

  def self.import_request(rails_request:, rails_controller:, rails_cookies: nil)
    if (router_conn = rails_request.instance_variable_get(:@kit_router_conn))
      return [:ok, router_conn: router_conn]
    end

    if rails_cookies
      _, cookies_ctx = import_rails_cookies(rails_cookies: rails_cookies)
      csrf_token     = rails_controller.session[:_csrf_token] ||= SecureRandom.base64(32)
      cookies        = cookies_ctx[:cookies]
    else
      cookies        = {}
    end

    env = rails_request
      .headers
      .to_h

    headers = env
      .select { |k, _v| k.starts_with?('HTTP') }
      .map { |k, v| [k.gsub('HTTP_', ''), v] }
      .to_h

    if (content_type = env['CONTENT_TYPE'])
      headers['CONTENT_TYPE'] = content_type
    end

    cgi = env
      .select { |k, _v| !k.starts_with?('HTTP') }
      .select { |k, _v| !k.starts_with?('action_') && !k.starts_with?('puma') && !k.starts_with?('rack') }

    cgi[:KIT_SILENCED_KEYS] = env.select { |k, _v| k.starts_with?('action_') || k.starts_with?('puma') || k.starts_with?('rack') }.keys

    params_query    = rails_request.query_parameters.deep_symbolize_keys
    params_body     = rails_request.request_parameters.to_h.deep_symbolize_keys rescue {} # rubocop:disable Style/RescueModifier

    path_parameters = rails_request.path_parameters.deep_symbolize_keys
    params_kit      = path_parameters.select { |k, _v| k.to_s.start_with?('kit_') } # No need to symbolize
    params_rails    = path_parameters.slice(:controller, :action).deep_symbolize_keys
    params_path     = path_parameters.except(*(params_rails.keys + params_kit.keys)).deep_symbolize_keys

    params          = params_query.merge(params_body).merge(params_path).deep_symbolize_keys

    kit_router_target  = params_kit[:kit_router_target]  || {}
    kit_request_config = params_kit[:kit_request_config] || {}

    router_conn = Kit::Router::Models::Conn.new(
      adapter:   :http_rails,

      route_id:  kit_router_target[:route_id],
      endpoint:  {
        id:       kit_router_target[:endpoint_id],
        callable: kit_router_target[:endpoint_callable],
      },

      client_ip: rails_request.ip,

      request:   {
        params:     params,
        params_kit: params_kit,

        http:       {
          cookies:      cookies,
          headers:      headers,
          user_agent:   rails_request.user_agent,
          csrf_token:   csrf_token,
          cgi:          cgi,

          params_query: params_query,
          params_body:  params_body,
          params_path:  params_path,
          params_rails: params_rails,
        },
      },

      response:  {
        content: nil,

        http:    {
          cookies: cookies.dup,
        },
      },

      metadata:  {
        adapters: {
          http_rails: {
            rails_controller: rails_controller,
            rails_request:    rails_request,
          },
        },
        config:   kit_request_config,
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
