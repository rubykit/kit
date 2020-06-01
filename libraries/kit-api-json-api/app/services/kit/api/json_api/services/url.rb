require 'uri'

# Namespace for URL related logic.
module Kit::Api::JsonApi::Services::Url

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  # Extract query parameters from an url string.
  def self.parse_query_params(url:)
    query_params_str = URI(url).query
    query_params     = Rack::Utils.parse_nested_query(query_params_str)
    query_params     = query_params.deep_symbolize_keys

    [:ok, query_params: query_params]
  end

end
