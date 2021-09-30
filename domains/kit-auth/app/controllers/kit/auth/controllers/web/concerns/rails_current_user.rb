module Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

  extend ActiveSupport::Concern

  included do
    before_action :resolve_current_user
  end

  def resolve_current_user
    Kit::Organizer.call(
      list: [
        Kit::Router::Adapters::HttpRails::Conn::Import.method(:import_request),
        [:alias, :web_resolve_current_user],
      ],
      ctx:  {
        rails_request:    request,
        rails_cookies:    cookies,
        rails_controller: self,
      },
    )
  end

  def session_user
    kit_router_conn = request.instance_variable_get(:@kit_router_conn)
    return nil if !kit_router_conn

    kit_router_conn.metadata[:session_user]
  end

  def session_user_access_token
    kit_router_conn = request.instance_variable_get(:@kit_router_conn)
    return nil if !kit_router_conn

    kit_router_conn.metadata[:session_user_access_token]
  end

  def request_user
    kit_router_conn = request.instance_variable_get(:@kit_router_conn)
    return nil if !kit_router_conn

    kit_router_conn.metadata[:request_user]
  end

  def request_user_access_token
    kit_router_conn = request.instance_variable_get(:@kit_router_conn)
    return nil if !kit_router_conn

    kit_router_conn.metadata[:request_user_access_token]
  end

end
