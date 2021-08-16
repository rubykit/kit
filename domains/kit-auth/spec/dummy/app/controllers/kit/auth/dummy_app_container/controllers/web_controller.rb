class Kit::Auth::DummyAppContainer::Controllers::WebController < Kit::DummyAppContainer::Controllers::WebController

  include Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    cookies,
      rails_controller: self,
      rails_response:   self.response,
    }

    _, ctx = Kit::Organizer.call(
      list: [
        Kit::Router::Services::Adapters::Http::Rails::Request::Import.method(:import_request),
        [:alias, :web_resolve_current_user],
        request.params[:kit_router_target],
      ],
      ctx:  controller_ctx,
    )

    Kit::Organizer.call(
      list: [
        Kit::Router::Services::Adapters::Http::Rails::Request::Export.method(:export_request),
      ],
      ctx:  controller_ctx.merge(ctx.slice(:router_request, :router_response)),
    )

    return
  end

end
