class Kit::DummyAppContainer::Controllers::WebController < ::ActionController::Base # rubocop:disable Style/Documentation

  protect_from_forgery

  # Add views directory of the dummy app
  if (views_path = KIT_APP_PATHS['GEM_SPEC_VIEWS'])
    prepend_view_path views_path
  end

  # Use custom layout if provided
  layout_name = KIT_APP_PATHS['GEM_SPEC_VIEW_LAYOUT'] || 'dummy_application'
  layout layout_name

  # Default route behaviour for Kit endpoints.
  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    cookies,
      rails_controller: self,
      rails_response:   self.response,
    }

    _status, ctx = Kit::Organizer.call(
      list: [
        Kit::Router::Services::Adapters::Http::Rails::Request::Import.method(:import_request),
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
