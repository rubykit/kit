require 'ostruct'

# Namespace for Kit::Router models definition.
module Kit::Router::Models # rubocop:disable Style/ClassAndModuleChildren

  # Request object.
  #
  class RouterRequest

    ATTRS = [:adapters, :endpoint, :ip, :metadata, :params, :route_id]

    attr_reader(*ATTRS)

    def initialize(params:, adapters: nil, endpoint: nil, ip: nil, metadata: nil, route_id: nil, **)
      @params   = params.is_a?(OpenStruct) ? params : OpenStruct.new(params)

      @adapters = adapters || {}
      @endpoint = endpoint || {}
      @ip       = ip
      @metadata = OpenStruct.new(metadata || {})
      @route_id = route_id
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
