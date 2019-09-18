class ::WebController < ::ActionController::Base
  include Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

  protect_from_forgery

  layout 'application'

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    cookies,
      rails_controller: self,
      rails_response:   self.response,
    }

    _, status, ctx = Kit::Organizer.call({
      list: [
        Kit::Router::Services::Request::Rails::Import.method(:import_request),
        :web_resolve_current_user,
        request.params[:kit_router_method],
      ],
      ctx: controller_ctx,
    })

    Kit::Organizer.call({
      list: [
        Kit::Router::Services::Request::Rails::Export.method(:export_request),
      ],
      ctx: controller_ctx.merge(ctx.slice(:request, :response)),
    })

    return
  end

end
