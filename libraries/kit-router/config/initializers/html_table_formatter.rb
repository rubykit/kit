if defined?(Rails)

  require 'action_dispatch/routing/inspector'
  require 'action_dispatch/middleware/debug_view'

  ActionDispatch::DebugView.class_eval do
    # Add Kit::Router views directory.
    def initialize(assigns)
      paths = [
        ActionDispatch::DebugView::RESCUES_TEMPLATE_PATH,
        File.expand_path('../../app/views', __dir__),
      ]
      lookup_context = ActionView::LookupContext.new(paths)
      super(lookup_context, assigns, nil)
    end
  end

  ActionDispatch::Routing::HtmlTableFormatter.class_eval do

    # Use Kit::Router templates
    def section(routes)
      @buffer << @view.render(partial: 'kit/router/routes/route', collection: routes)
    end

    # Use Kit::Router templates
    def result
      @view.raw @view.render(layout: 'kit/router/routes/table') {
        @view.raw @buffer.join("\n")
      }
    end

    # Do not display Engine name as a row.
    def section_title(title)
      #@buffer << %(<tr><th colspan="4">#{title}</th></tr>)
    end

  end

  ActionDispatch::DebugExceptions.class_eval do

    def render_for_browser_request(request, wrapper)
      template = create_template(request, wrapper)

      file = "rescues/#{ wrapper.rescue_template }"

      if request.xhr?
        body = template.render(template: file, layout: false, formats: [:text])
        format = 'text/plain'
      else
        # Replace generic templates by Kit version
        if wrapper.rescue_template == 'routing_error'
          file   = "kit/router/rescues/#{ wrapper.rescue_template }"
          layout = 'kit/router/rescues/layout'
        else
          layout = 'rescues/layout'
        end

        body = template.render(template: file, layout: layout)
        format = 'text/html'
      end
      render(wrapper.status_code, body, format)
    end

  end

  ActionDispatch::Routing::RoutesInspector.class_eval do

    # Add extra route info.
    def collect_routes(routes, engine_name = nil)
      routes
        .collect do |route|
          ActionDispatch::Routing::RouteWrapper.new(route)
        end
        .reject(&:internal?)
        .collect do |route|
          collect_engine_routes(route)

          {
            name:            route.name,
            verb:            route.verb,
            path:            route.path,
            reqs:            route.reqs,
            endpoint:        route.endpoint,
            type:            route.requirements[:kit_router_target] ? :kit : :rails,
            kit_endpoint_id: route.requirements.dig(:kit_router_target, :endpoint_id),
            kit_route_id:    route.requirements.dig(:kit_router_target, :route_id),
            engine_name:     engine_name,
          }
        end
    end
  end

  # Forward engine name to collect_routes
  def collect_engine_routes(route)
    name = route.endpoint
    return unless route.engine?
    return if @engines[name]

    routes = route.rack_app.routes
    if routes.is_a?(ActionDispatch::Routing::RouteSet)
      @engines[name] = collect_routes(routes.routes, name)
    end
  end

end
