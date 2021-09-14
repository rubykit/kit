require 'ostruct'

# Namespace for Kit::Router models definition.
module Kit::Router::Models # rubocop:disable Style/ClassAndModuleChildren

  # Request object.
  #
  class RouterRequest

    ATTRS = [:adapters, :endpoint, :ip, :metadata, :params, :route_id]

    attr_reader(*ATTRS)

    def initialize(params:, adapters: nil, endpoint: nil, ip: nil, metadata: nil, route_id: nil, **)
      #@params   = params.is_a?(OpenStruct) ? params : OpenStruct.new(params)
      @params   = params   || {}

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
      {
        route_id: route_id.dup,
        params:   params.deep_dup,
        ip:       ip.dup,

        adapters: adapters.deep_dup,
        endpoint: endpoint.deep_dup,
        metadata: metadata.to_h,
      }
    end

    def ai(*options)
      hash = self.to_h

      # NOTE: too big to display, with little value
      if hash.dig(:adapters, :http_rails, :rails_request)
        tmp_hash = {}
        tmp_hash.__ap_nest__ = true
        tmp_hash.__ap_log_name__ = ->(*) { 'ActionDispatch::Request' }

        hash[:adapters][:http_rails][:rails_request] = tmp_hash
      end

      if (headers = hash.dig(:adapters, :http_rails, :headers))
        headers = headers.env.to_h

        hash[:adapters][:http_rails][:headers] = headers
          .select { |k, _v| !k.starts_with?('action_') && !k.starts_with?('puma') }

        hash[:adapters][:http_rails][:headers][:AWESOME_PRINT_SUPPRESSED_KEYS] = headers
          .keys
          .select { |k| k.starts_with?('action_') || k.starts_with?('puma') }
      end

      hash.ai(*options)
    end

  end

end
