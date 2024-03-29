# Transform hydrated query_params data to an actionable Request.
module Kit::Api::JsonApi::Services::Request

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  # Takes hydrated query params to create a Request.
  # @see Kit::Api::JsonApi::Contracts#Request
  def self.create_api_request(query_params:)
    Kit::Api::JsonApi::Services::Request::Export.import(query_params: query_params)
  end

  def self.create_query_params(api_request:, path:)
    Kit::Api::JsonApi::Services::Request::Export.export(api_request: api_request, path: path)
  end

end
