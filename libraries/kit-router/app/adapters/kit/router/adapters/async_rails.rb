module Kit::Router::Adapters::AsyncRails

  def self.call(router_request:)
    Kit::Organizer.call(
      list: [
        self.method(:enqueue_job),
      ],
      ctx:  {
        router_request: router_request,
      },
    )
  end

  def self.cast(router_request:)
    call(router_request: router_request)

    [:ok]
  end

  def self.enqueue_job(router_request:)
    job = default_job_adapter.perform_later(
      route_id:     router_request[:route_id],
      endpoint_uid: router_request[:endpoint][:uid],
      params:       router_request[:params].to_h,
    )

    [:ok, {
      router_response: {
        mime:    :ruby,
        content: {
          job_id: job.provider_job_id,
        },
      },
    },]
  end

  class << self

    attr_accessor :default_job_adapter

  end

end
