# HTTP request adapter.
module Kit::Domain::Endpoints::Http

  def self.render(router_conn:, component:, params: nil, status: nil)
    status ||= 200
    params ||= {}

    page    = component.new(**params)
    content = page.local_render(router_conn: router_conn)

    response = router_conn[:response]

    response[:content]       = content
    response[:http][:status] = status
    response[:http][:mime]   = :html

    [:ok, router_conn: router_conn]
  end

  # LINK: https://en.wikipedia.org/wiki/HTTP_302
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

  def self.attempt_redirect_with_errors(router_conn:, redirect_url: nil, errors: nil)
    return [:ok] if !redirect_url

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        error: errors.map { |el| el[:detail] }.join('<br>'),
      },
    )
  end

end
