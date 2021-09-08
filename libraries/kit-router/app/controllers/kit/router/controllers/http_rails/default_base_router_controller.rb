# HttpRails adapter default catch-all controller.
#
# This is more of a template than anything, each app container should define its own variation.
#
class Kit::Router::Controllers::HttpRails::DefaultBaseRouterController < ::ActionController::Base

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    cookies,
      rails_controller: self,
      rails_response:   self.response,
    }

    _status, ctx = Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::HttpRails::Request::Import.method(:import_request),
        ->(router_request:) { router_request.endpoint[:callable].call(router_request: router_request) },
      ],
      ctx:  controller_ctx,
    )

    # NOTE: we need to run this regardless of the previous status
    Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::HttpRails::Request::Export.method(:export_request),
      ],
      ctx:  controller_ctx.merge(ctx.slice(:router_request, :router_response)),
    )

    return
  end

end
