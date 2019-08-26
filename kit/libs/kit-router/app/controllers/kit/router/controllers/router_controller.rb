module Kit::Router::Controllers
  class RouterController < ::WebController

    def route
      controller_ctx = {
        rails_request:    self.request,
        rails_cookies:    cookies,
        rails_controller: self,
      }

      status, ctx = Kit::Organizer.call({
        list: [
          Kit::Router::Services::Request::Rails::Import.method(:import_request),
          # NOTE: should this be here?
          :resolve_current_user,
          request.params[:kit_router_method],
          Kit::Router::Services::Request::Rails::Export.method(:export_request),
        ],
        ctx: controller_ctx,
      })

      return
    end

  end
end
