# Namespace for the API engine.
module Kit::JsonApi::Services::JsonApi

=begin
  def self.serialize_response(document:)
    [:ok, json_str: Oj.dump(document, mode: :compat)]
  end

  def self.json_api_result_to_response(json_api_result_hash:, status: 200)
    string_content = Oj.dump(json_api_result_hash, mode: :compat)

    [:ok, {
      response: {
        mime:     :json_api,
        content:  json_api_result_hash,
        metadata: {
          http: {
            status: status,
          },
        },
      },
    }]
  end
=end

end
