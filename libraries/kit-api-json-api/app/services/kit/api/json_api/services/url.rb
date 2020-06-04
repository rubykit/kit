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

  # Generate string version of `query_params`
  def self.serialize_query_params(query_params:)
    str = Rack::Utils.build_nested_query(query_params)

    [:ok, query_params_str: str]
  end

  def self.path_to_link(url_path:, query_params:)
    link = (url_path.size == 0) ? '/' : url_path.dup

    query_params_str = serialize_query_params(query_params: query_params)[1][:query_params_str]

    if query_params_str.size > 0
      link = "#{ link }?#{ query_params_str }"
    end

    [:ok, link: link]
  end

end
