require 'oj'

module Kit::Router::Controllers

  # HTTP request adapter.
  module Http

    def self.render(component:, params:, status: 200)
      page    = component.new(**params)
      content = page.local_render

      [:ok, {
        router_response: {
          mime:     :html,
          content:  content,
          metadata: {
            http: {
              status: status,
            },
          },
        },
      },]
    end

    def self.render_jsonapi_errors(resources:, status:, meta: {}, serializers: nil)
      serializers ||= {
        Hash: JSONAPI::Rails::SerializableErrorHash,
      }

      renderer = JSONAPI::Serializable::Renderer.new
      options  = {
        class: serializers,
      }
      if !meta.empty?
        options[:meta] = meta
      end

      content  = renderer.render_errors(resources, options)
      content  = Oj.dump(content, mode: :compat)

      [:error, {
        router_response: {
          mime:     :json_api,
          content:  content,
          metadata: {
            http: {
              status: status,
            },
          },
        },
      },]
    end

    def self.render_jsonapi(resources:, serializers:, fields: {}, sideload: {}, links: {}, meta: {}, status: 200)
      renderer = JSONAPI::Serializable::Renderer.new
      options  = {
        class:   serializers,
        fields:  fields,
        include: sideload,
        links:   links.respond_to?(:call) ? links.call(resources: resources) : links,
      }

      if !meta.empty?
        options[:meta] = meta
      end

      content  = renderer.render(resources, options)
      content  = Oj.dump(content, mode: :compat)

      [:ok, {
        router_response: {
          mime:     :json_api,
          content:  content,
          metadata: {
            http: {
              status: status,
            },
          },
        },
      },]
    end

    # LINK: https://en.wikipedia.org/wiki/HTTP_302
    def self.redirect_to(location:, status: 302, domain: nil, notice: nil, alert: nil)
      status = 302 if status.blank?

      [:ok_stop, {
        router_response: {
          metadata: {
            http: {
              status:   status,
              redirect: {
                location: location,
                domain:   domain,
                notice:   notice,
                alert:    alert,
              },
            },
          },
        },
      },]
    end

  end
end
