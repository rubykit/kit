# Mixin that can be used as the route wrapper for endpoints.
module Kit::Router::Controllers::Concerns::DefaultRouter

  extend ActiveSupport::Concern

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    cookies,
      rails_controller: self,
      rails_response:   self.response,
    }

    _status, ctx = Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::HttpRails::Conn::Import.method(:import_request),
        ->(router_conn:) { router_conn.endpoint[:callable].call(router_conn: router_conn) },
      ],
      ctx:  controller_ctx,
    )

    # NOTE: we need to run this regardless of the previous status
    Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::HttpRails::Conn::Export.method(:export_response),
      ],
      ctx:  controller_ctx.merge(ctx.slice(:router_conn)),
    )

    return
  end

end
