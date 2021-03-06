require 'uri'

module Kit::Router::Services::Adapters::Http

  # Mountpoint related logic.
  module Mountpoints

    def self.path(id:, params: {})
      _, res = Kit::Router::Services::Store::Mountpoint.find_mountpoint(id: id, mountpoint_type: [:http, :rails])
      path   = res.dig(:mountpoint_data, :data, 1)

      if path.blank?
        raise "Kit::Router | not mounted `#{ id }`"
      end

      uri = URI(path)

      new_path = uri.path

      params = params.map do |k, v|
        marker = ":#{ k }"
        if path.include?(marker)
          new_path.gsub!(marker, v.to_s)
          nil
        else
          [k, v]
        end
      end.compact.to_h

      uri.path = new_path
      uri.query = Rack::Utils
        .parse_nested_query(uri.query)
        .merge(params)
        .to_query

      uri.to_s.gsub(%r{\?$}, '')
    end

    def self.url(id:, params: {})
      host   = ENV['URI_HOST']
      scheme = ENV['URI_SCHEME']

      if scheme.blank?
        scheme = 'http'
      end

      # TODO: fix this
      if host.blank?
        port = 3000
        host = 'localhost'
      end

      current_path = path(id: id, params: params)

      uri          = URI(current_path)
      uri.host     = host
      uri.port     = port
      uri.scheme   = scheme

      uri.to_s
    end

    def self.verb(id:)
      _, res = Kit::Router::Services::Store::Mountpoint.find_mountpoint(id: id, mountpoint_type: [:http, :rails])
      verb   = res.dig(:mountpoint_data, :data, 0)

      if verb.blank?
        raise "Kit::Router | not mounted `#{ id }`"
      end

      verb
    end

    def self.request_route?(request:, id:, params: {})
      request_url = request&.url
      return false if request_url.blank?

      id_path = path(id: id, params: params)

      URI(request_url).path == URI(id_path).path
    end

  end
end
