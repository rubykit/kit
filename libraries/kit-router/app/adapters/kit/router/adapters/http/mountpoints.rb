require 'uri'

# Mountpoint related logic.
module Kit::Router::Adapters::Http::Mountpoints

  def self.path(id:, params: nil, mountpoint_type: nil)
    params          ||= {}
    mountpoint_type ||= [:http, :rails]

    _, res = Kit::Router::Services::Store::Mountpoint.find_mountpoint(id: id, mountpoint_type: mountpoint_type)
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

  def self.base_url
    ENV['URL']
  end

  def self.url(id:, params: nil, mountpoint_type: nil)
    path = path(id: id, params: params, mountpoint_type: mountpoint_type)

    "#{ base_url }#{ path }"
  end

  def self.verb(id:, mountpoint_type: nil)
    mountpoint_type ||= [:http, :rails]

    _, res = Kit::Router::Services::Store::Mountpoint.find_mountpoint(id: id, mountpoint_type: mountpoint_type)
    verb   = res.dig(:mountpoint_data, :data, 0)

    if verb.blank?
      raise "Kit::Router | not mounted `#{ id }`"
    end

    verb
  end

  def self.request_route?(request:, id:, params: nil, mountpoint_type: nil)
    params          ||= {}
    mountpoint_type ||= [:http, :rails]

    request_url = request&.url
    return false if request_url.blank?

    id_path = path(id: id, params: params, mountpoint_type: mountpoint_type)

    URI(request_url).path == URI(id_path).path
  end

end
