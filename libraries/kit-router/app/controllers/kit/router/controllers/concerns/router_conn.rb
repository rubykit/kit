# Mixin to resolve :router_conn on Rails controllers.
module Kit::Router::Controllers::Concerns::RouterConn

  extend ActiveSupport::Concern

  def get_kit_router_conn
    @kit_router_conn ||= request.instance_variable_get(:@kit_router_conn)

    if !@kit_router_conn
      Kit::Organizer.call(
        list: [
          Kit::Router::Adapters::HttpRails::Conn::Import.method(:import_request),
        ],
        ctx:  {
          rails_request:    request,
          rails_cookies:    cookies,
          rails_controller: self,
        },
      )

      @kit_router_conn ||= request.instance_variable_get(:@kit_router_conn)
    end

    @kit_router_conn
  end

end
