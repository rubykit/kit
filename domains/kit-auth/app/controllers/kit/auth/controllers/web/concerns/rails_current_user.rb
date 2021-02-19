module Kit::Auth::Controllers::Web::Concerns
  module RailsCurrentUser
    extend ActiveSupport::Concern

    included do
      before_action :resolve_current_user
    end

    def resolve_current_user
      Kit::Organizer.call(
        # TODO: should there be an explicit or impliticit reference ?
        list: [
          Kit::Router::Services::Adapters::Http::Rails::Request::Import.method(:import_request),
          [:alias, :web_resolve_current_user],
        ],
        ctx:  {
          rails_request:    request,
          rails_cookies:    cookies,
          rails_controller: self,
        },
      )
    end

    def current_user
      kit_router_request = request.instance_variable_get(:@kit_router_request)
      return nil if !kit_router_request

      kit_router_request.metadata[:current_user]
    end

    def current_user_oauth_access_token
      kit_router_request = request.instance_variable_get(:@kit_router_request)
      return nil if !kit_router_request

      kit_router_request.metadata[:current_user_oauth_access_token]
    end

  end
end
