# Mixin that can be used as the route wrapper for endpoints.
module Kit::Api::JsonApi::Controllers::Concerns::DefaultRoute

  extend ActiveSupport::Concern

  def route
    controller_ctx = {
      rails_request:    self.request,
      rails_controller: self,
      rails_response:   self.response,
    }

    Kit::Organizer.call(
      ok:    [
        Kit::Router::Adapters::HttpRails::Conn::Import.method(:import_request),
        [:nest, {
          ok:    [
            ->(router_conn:) { [:ok, query_params: router_conn.request[:params].to_h] },
            ->(router_conn:) do
              [:ok, api_request: {
                config:             router_conn.config[:api],
                top_level_resource: router_conn.request[:params_kit][:kit_api_top_level_resource],
                singular:           router_conn.request[:params_kit][:kit_api_singular],
              },]
            end,
            Kit::Api::JsonApi::Services::Endpoints::Guards.method(:ensure_media_type),
            ->(router_conn:, query_params:, api_request:) do
              router_conn.endpoint[:callable].call(router_conn: router_conn, query_params: query_params, api_request: api_request)
            end,
            Kit::Api::JsonApi::Services::Endpoints::Success.method(:generate_success_router_response),
          ],
          error: [
            Kit::Api::JsonApi::Services::Endpoints::Error.method(:generate_response),
          ],
        },],
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
