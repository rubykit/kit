module Kit::JsonApi::Controllers
  module JsonApi

    JSONAPI_MEDIA_TYPE = 'application/vnd.api+json'.freeze

    def self.ensure_media_type(request:)
      Kit::Organizer.call({
        list: [
          self.method(:ensure_content_type),
          self.method(:ensure_http_accept),
        ],
        ctx: { request: request, },
      })
    end

    def self.ensure_content_type(request:)
      content_type = request.http.headers['CONTENT_TYPE']

      if Rack::MediaType.type(content_type) == JSONAPI_MEDIA_TYPE && Rack::MediaType.params(content_type) == {}
        return [:ok]
      end

      [:error, {
        response: {
          metadata: {
            http: {
              status: 415,
            },
          },
        },
      }]
    end

    def self.ensure_http_accept(request:)
      http_accept = request.http.headers['ACCEPT']

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
        response: {
          metadata: {
            http: {
              status: 406,
            },
          },
        },
      }]
    end

  end
end