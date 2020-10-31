class Kit::DummyAppContainer::Controllers::WebController < ::ActionController::Base # rubocop:disable Style/Documentation

  protect_from_forgery

  layout 'dummy_application'

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    cookies,
      rails_controller: self,
      rails_response:   self.response,
    }

    _status, ctx = Kit::Organizer.call({
      list: [
        Kit::Router::Services::Adapters::Http::Rails::Request::Import.method(:import_request),
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
