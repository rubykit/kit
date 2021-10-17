# Mixin that can be used as the route wrapper for endpoints.
module Kit::Auth::Controllers::Web::Concerns::DefaultRoute

  extend ActiveSupport::Concern

  included do
    include Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

    protect_from_forgery with: :exception
  end

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_cookies:    cookies,
      rails_controller: self,
      rails_response:   self.response,
    }

    Kit::Organizer.call(
      ok:    [
        Kit::Router::Adapters::HttpRails::Conn::Import.method(:import_request),
        [:alias, :web_resolve_current_user],
        ->(router_conn:) { router_conn.endpoint[:callable].call(router_conn: router_conn) },
        Kit::Router::Adapters::HttpRails::Conn::Export.method(:export_response),
      ],
      error: [
        Kit::Router::Adapters::HttpRails::Conn::Export.method(:export_response),
      ],
      ctx:   controller_ctx,
    )

    return
  end

end
