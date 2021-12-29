# HTTP request adapter helpers.
module Kit::Domain::Endpoints::Http

  # Render a component & setup the `:router_conn`'s `response` for http.
  def self.render(router_conn:, component:, params: nil, status: nil, layout: nil)
    status ||= 200
    params ||= {}

    params[:router_conn] = router_conn if !params[:router_conn]

    page    = component.new(**params)
    content = page.local_render(router_conn: router_conn)

    response = router_conn[:response]

    response[:content]       = content
    response[:http][:status] = status
    response[:http][:mime]   = :html
    response[:http][:layout] = layout.is_a?(Symbol) ? layout.to_s : layout

    [:ok, router_conn: router_conn]
  end

  # Setup the `:router_conn`'s `response` for a http redirect.
  #
  # ⚠️ Returns a `:halt`, so if it used directly inside an endpoint wrapper it can halt the entire response flow.
  #
  # ### References
  # - https://en.wikipedia.org/wiki/HTTP_302
  def self.redirect_to(router_conn:, location:, status: 302, domain: nil, flash: nil)
    status = 302 if status.blank?

    response = router_conn[:response]

    response[:http][:status]   = status
    response[:http][:redirect] = {
      location: location,
      domain:   domain,
      flash:    flash || {},
    }

    [:halt, router_conn: router_conn]
  end

  # Render a "page" component & setup the `:router_conn`'s `response` for http.
  def self.render_form_page(router_conn:, form_model:, component:, errors: nil)
    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:   component,
      params:      {
        csrf_token:  router_conn.request[:http][:csrf_token],
        errors_list: errors,
        model:       form_model,
      },
    )
  end

  # Setup the `:router_conn`'s `response` for a http redirect taking into account errors.
  #
  # ⚠️ Returns a `:halt`, so if it used directly inside an endpoint wrapper it can halt the entire response flow.
  def self.redirect_with_errors(router_conn:, redirect_url:, errors: nil)
    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        error: errors.map { |el| el[:detail] }.join('<br>'),
      },
    )
  end

  # Call `.redirect_with_errors` if a non nil `:redirect_url` is present in the context.
  #
  # ⚠️ Returns a `:halt`, so if it used directly inside an endpoint wrapper it can halt the entire response flow.
  def self.attempt_redirect_with_errors(router_conn:, redirect_url: nil, errors: nil)
    return [:ok] if !redirect_url

    redirect_with_errors(
      router_conn:  router_conn,
      redirect_url: redirect_url,
      errors:       nil,
    )
  end

  def self.halt_if_redirect!(router_conn:)
    if router_conn.dig(:response, :http, :redirect, :location)
      [:halt]
    else
      [:ok]
    end
  end

end
