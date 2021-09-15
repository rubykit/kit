require 'oj'

# HTTP request adapter.
module Kit::Router::Controllers::Http

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
  def self.redirect_to(router_conn:, location:, status: 302, domain: nil, notice: nil, alert: nil)
    status = 302 if status.blank?

    response = router_conn[:response]

    response[:http][:status]   = status
    response[:http][:redirect] = {
      location: location,
      domain:   domain,
      notice:   notice,
      alert:    alert,
    }

    [:halt, router_conn: router_conn]
  end

end
