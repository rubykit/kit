module Kit::JsonApi::Services::QuerySerializer

  def self.serialize(json_api_query:)
    binding.pry
    [:ok]
  end

  def self.to_result_hash(json_api_query:)
    #binding.pry

    json_api_result_hash = {
      data:     [],
      included: [],
    }

    #add_data()

    #json_api_result_hash

    [:ok, json_api_result_hash: json_api_result_hash]
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

end