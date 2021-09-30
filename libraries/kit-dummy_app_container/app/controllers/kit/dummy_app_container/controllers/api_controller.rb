class Kit::DummyAppContainer::Controllers::ApiController < ::ActionController::API # rubocop:disable Style/Documentation

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    {},
      rails_controller: self,
      rails_response:   self.response,
    }

    _, ctx = Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::HttpRails::Conn::Import.method(:import_request),
        :api_resolve_request_user,
        ->(router_conn:) { router_conn.endpoint[:callable].call(router_conn: router_conn) },
      ],
      ctx:  controller_ctx,
    )

    Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::HttpRails::Conn::Export.method(:export_response),
      ],
      ctx:  controller_ctx.merge(ctx.slice(:router_conn)),
    )

    return
  end

end
