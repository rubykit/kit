# Adapter to call endpoints asyncronously.
#
# This adapter is a wrapper around ActiveJobs.
module Kit::Router::Adapters::AsyncRails

  def self.call(router_conn:)
    Kit::Organizer.call(
      list: [
        self.method(:enqueue_job),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  def self.cast(router_conn:)
    call(router_conn: router_conn)

    [:ok]
  end

  def self.enqueue_job(router_conn:)
    job = default_job_adapter.perform_later(
      route_id:     router_conn[:route_id],
      endpoint_uid: router_conn[:endpoint][:uid],
      params:       router_conn[:request][:params].to_h,
    )

    router_conn[:response][:content] = {
      job_id: job.provider_job_id,
    }

    [:ok, router_conn: router_conn]
  end

  class << self

    attr_accessor :default_job_adapter

  end

end
