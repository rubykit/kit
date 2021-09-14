class ApplicationJob < ActiveJob::Base

  def perform(route_id:, endpoint_uid:, params:)
    Kit::Router::Services::Adapters.call(
      route_id:     route_id,
      adapter_name: :inline,
      params:       params,
    )
  end

end
