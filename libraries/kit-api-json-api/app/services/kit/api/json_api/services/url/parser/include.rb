# Transform the `include` query parameter into something usable.
module Kit::Api::JsonApi::Services::Url::Parser::Include

  include Kit::Contract
  Ct = Kit::Api::JsonApi::Contracts

  # @example GET /authors/1?include=books.chapters,photos
  # @see https://jsonapi.org/format/1.1/#fetching-includes
  def self.parse_include(query_params_in:, query_params_out:)
    data = (query_params_in[:include] || '').split(',')

    query_params_out[:include] = data

    [:ok, query_params_out: query_params_out]
  end

end
