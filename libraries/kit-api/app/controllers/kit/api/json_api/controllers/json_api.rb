require 'oj'

# Shared controller logic
module Kit::Api::JsonApi::Controllers::JsonApi

  def self.generate_success_router_response(document:, status_code: nil)
    status_code ||= 200

    if status_code == 204
      content = nil
    else
      content = document[:response]
    end

    content_json = content ? ::Oj.dump(content, mode: :json) : nil

    [:ok, {
      router_response: {
        mime:     :json_api,
        content:  content_json,
        metadata: {
          http: {
            status: status_code,
          },
        },
      },
    },]
  end

  JSONAPI_MEDIA_TYPE = 'application/vnd.api+json'.freeze

  def self.ensure_media_type(router_request:)
    Kit::Organizer.call(
      list: [
        self.method(:ensure_content_type),
        self.method(:ensure_http_accept),
      ],
      ctx:  { router_request: router_request },
    )
  end

  # ### References
  # - https://jsonapi.org/format/1.1/#content-negotiation-servers
  def self.ensure_content_type(router_request:)
    content_type = router_request.adapters[:http_rails][:headers]['CONTENT_TYPE']

    if Rack::MediaType.type(content_type) == JSONAPI_MEDIA_TYPE && Rack::MediaType.params(content_type) == {}
      return [:ok]
    end

    return [:ok] if Kit::Config[:ENV_TYPE].include?(:development)

    [:error, { status_code: 415, detail: "Expected Content-Type header `#{ JSONAPI_MEDIA_TYPE }` but got `#{ content_type }`." }]
  end

  # ### References
  # - https://jsonapi.org/format/1.1/#content-negotiation-servers
  def self.ensure_http_accept(router_request:)
    http_accept = router_request.adapters[:http_rails][:headers]['ACCEPT']

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
