require 'ostruct'

# Namespace for Kit::Router models definition.
module Kit::Router::Models # rubocop:disable Style/ClassAndModuleChildren

  # Request object.
  #
  # ### References
  # - https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/http/headers.rb
  # - https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/http/request.rb
  #
  class RouterRequest

    ATTRS = [:params, :root, :http, :metadata, :ip, :rails, :target]

    attr_reader(*ATTRS)

    def initialize(params:, root: nil, http: nil, metadata: nil, ip: nil, target: nil, rails: nil, **)
      @params = params
      @ip     = ip
      @root   = root

      @target = target || {}
      @rails  = rails  || {}

      @http = OpenStruct.new(http || {
        csrf_token: nil,
        cookies:    {},
        headers:    {},
        user_agent: nil,
      })

      @metadata = OpenStruct.new(metadata || {})
    end

    def [](name)
      send(name.to_sym)
    end

    def dig(name, *names)
      name = name.to_sym
      if name.in?(ATTRS)
        send(name).dig(*names)
      else
        nil
      end
    end

    def to_h
      http_dup = http.dup
      http_dup.headers = http_dup.headers
        .env
        .to_h
        .select { |k, _v| !k.starts_with?('action_') }

      {
        params:   params,
        ip:       ip,
        root:     root,
        http:     http_dup,
        metadata: metadata,
      }
    end

    # NOTE: hacky way to not pollute output with `root`, not proud of it.
    def ai(*options)
      root_saved = @root

      tmp_hash = {}
      tmp_hash.__ap_nest__ = true
      tmp_hash.__ap_log_name__ = ->(*) { 'ActionDispatch::Request' }

      @root = tmp_hash

      result = self.to_h.ai(*options)

      @root = root_saved

      result
    end

  end

end
