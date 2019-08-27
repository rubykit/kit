module Kit::Router::Controllers
  class RouterController < ::WebController

    def route
      controller_ctx = {
        rails_request:    self.request,
        rails_cookies:    cookies,
        rails_controller: self,
        rails_response:   self.response,
      }

      status, ctx = Kit::Organizer.call({
        list: [
          Kit::Router::Services::Request::Rails::Import.method(:import_request),
          # NOTE: should this be here?
          :resolve_current_user,
          request.params[:kit_router_method],
        ],
        ctx: controller_ctx,
      })

      # NOTE: we need to run this regardless of the previous status
      Kit::Organizer.call({
        list: [
          Kit::Router::Services::Request::Rails::Export.method(:export_request),
        ],
        ctx: controller_ctx.merge(ctx.slice(:request, :response)),
      })

      return
    end

  end
end
