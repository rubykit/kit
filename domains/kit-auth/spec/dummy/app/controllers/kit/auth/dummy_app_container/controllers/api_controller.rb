class Kit::Auth::DummyAppContainer::Controllers::ApiController < ::ActionController::API # :nodoc:

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    {},
      rails_controller: self,
      rails_response:   self.response,
    }

    _, ctx = Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::HttpRails::Request::Import.method(:import_request),
        [:alias, :api_resolve_current_user],
        ->(router_request:) { router_request.endpoint[:callable].call(router_request: router_request) },
      ],
      ctx:  controller_ctx,
    )

    Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::HttpRails::Request::Export.method(:export_request),
      ],
      ctx:  controller_ctx.merge(ctx.slice(:router_request, :router_response)),
    )

    return
  end

end
