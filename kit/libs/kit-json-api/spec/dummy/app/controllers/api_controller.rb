class ::ApiController < ::ActionController::API # :nodoc:

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

    _, ctx = Kit::Organizer.call({
      list: [
        Kit::Router::Services::Adapters::Http::Rails::Request::Import.method(:import_request),
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