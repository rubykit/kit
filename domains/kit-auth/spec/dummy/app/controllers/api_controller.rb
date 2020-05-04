class ::ApiController < ::ActionController::API # :nodoc:

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    {},
      rails_controller: self,
      rails_response:   self.response,
    }

    _, ctx = Kit::Organizer.call({
      list: [
        Kit::Router::Services::Adapters::Http::Rails::Request::Import.method(:import_request),
        :api_resolve_current_user,
        request.params[:kit_router_target],
      ],
      ctx: controller_ctx,
    })

    Kit::Organizer.call({
      list: [
        Kit::Router::Services::Adapters::Http::Rails::Request::Export.method(:export_request),
      ],
      ctx: controller_ctx.merge(ctx.slice(:request, :response)),
    })

    return
  end

end