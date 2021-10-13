require 'oj'

module Kit::Api::JsonApi::Services::Endpoints::Guards

  JSONAPI_MEDIA_TYPE = 'application/vnd.api+json'.freeze

  def self.ensure_media_type(router_conn:)
    Kit::Organizer.call(
      list: [
        self.method(:ensure_content_type),
        self.method(:ensure_http_accept),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  # ### References
  # - https://jsonapi.org/format/1.1/#content-negotiation-servers
  def self.ensure_content_type(router_conn:)
    content_type = router_conn.request[:http][:headers]['CONTENT_TYPE']

    if Rack::MediaType.type(content_type) == JSONAPI_MEDIA_TYPE && Rack::MediaType.params(content_type) == {}
      return [:ok]
    end

    return [:ok] if Kit::Config[:ENV_TYPE].include?(:development)

    [:error, { status_code: 415, detail: "Expected Content-Type header `#{ JSONAPI_MEDIA_TYPE }` but got `#{ content_type }`." }]
  end

  # ### References
  # - https://jsonapi.org/format/1.1/#content-negotiation-servers
  def self.ensure_http_accept(router_conn:)
    http_accept = router_conn.request[:http][:headers]['ACCEPT']

    if http_accept.blank?
      return [:ok]
    end

    jsonapi_media_types = http_accept
      .split(',')
      .map(&:strip)
      .select { |m| Rack::MediaType.type(m) == JSONAPI_MEDIA_TYPE }

    if !jsonapi_media_types.empty? && !jsonapi_media_types.any? { |m| Rack::MediaType.params(m) != {} }
      return [:ok]
    end

    return [:ok] if Kit::Config[:ENV_TYPE].include?(:development)

    [:error, { status_code: 406, detail: "Expected Accept header to contain `#{ JSONAPI_MEDIA_TYPE }`." }]
  end

end
