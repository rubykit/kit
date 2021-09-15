class ::ApiController < ::ActionController::API # rubocop:disable Style/Documentation

  # NOTE: right now we need to overwrite the default dummy one as it references kit-auth code.
  #  We need to solve this somehow, maybe via Plug / Pipelines ?
  #  OR: live with it and just register an enpty callable instead ?
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
