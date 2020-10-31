class Kit::Auth::DummyAppContainer::Controllers::WebController < ::ActionController::Base

  include Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

  protect_from_forgery

  if (layout_name = KIT_APP_PATHS['GEM_SPEC_VIEW_LAYOUT'])
    layout layout_name
  end

  if (views_path = KIT_APP_PATHS['GEM_SPEC_VIEWS'])
    prepend_view_path views_path
  end

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    cookies,
      rails_controller: self,
      rails_response:   self.response,
    }

    _, ctx = Kit::Organizer.call({
      list: [
        Kit::Router::Services::Adapters::Http::Rails::Request::Import.method(:import_request),
        [:alias, :web_resolve_current_user],
        request.params[:kit_router_target],
      ],
      ctx:  controller_ctx,
    })

    Kit::Organizer.call({
      list: [
        Kit::Router::Services::Adapters::Http::Rails::Request::Export.method(:export_request),
      ],
      ctx:  controller_ctx.merge(ctx.slice(:router_request, :router_response)),
    })

    return
  end

end
