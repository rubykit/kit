# NOTE: More of a template than anything, each app container should define its own variations!

module Kit::Router::Controllers::Rails
  class DefaultBaseRouterController < ::ActionController::Base

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
          request.params[:kit_router_target],
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