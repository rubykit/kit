module Kit::Domain::Controllers
  module JsonApi

    JSONAPI_MEDIA_TYPE = 'application/vnd.api+json'.freeze

    def self.ensure_media_type(router_request:)
      Kit::Organizer.call({
        list: [
          self.method(:ensure_content_type),
          self.method(:ensure_http_accept),
        ],
        ctx:  { router_request: router_request },
      })
    end

    def self.ensure_content_type(router_request:)
      content_type = router_request.http.headers['CONTENT_TYPE']

      if Rack::MediaType.type(content_type) == JSONAPI_MEDIA_TYPE && Rack::MediaType.params(content_type) == {}
        return [:ok]
      end

      [:error, {
        router_response: {
          metadata: {
            http: {
              status: 415,
            },
          },
        },
      },]
    end

    def self.ensure_http_accept(router_request:)
      http_accept = router_request.http.headers['ACCEPT']

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

      [:error, {
        router_response: {
          metadata: {
            http: {
              status: 406,
            },
          },
        },
      },]
    end

  end
end
