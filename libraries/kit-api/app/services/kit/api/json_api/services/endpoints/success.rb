require 'oj'

module Kit::Api::JsonApi::Services::Endpoints::Success

  def self.generate_success_router_response(router_conn:, document:, status_code: nil)
    status_code ||= 200

    if status_code == 204
      content = nil
    else
      content = document[:response]
    end

    content_json = content ? ::Oj.dump(content, mode: :json) : nil

    router_conn[:response].deep_merge!({
      content: content_json,
      http:    {
        status: status_code,
        mime:   :json_api,
      },
    })

    [:ok, router_conn: router_conn]
  end

end
