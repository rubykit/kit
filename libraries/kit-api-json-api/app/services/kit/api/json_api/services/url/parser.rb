require 'uri'
#require 'Rack'

# Transform query parameters into something usable.
module Kit::Api::JsonApi::Services::Url::Parser

  include Kit::Contract
  Ct = Kit::Api::JsonApi::Contracts

  def self.parse_url(url:)
    query_params_str = URI(url).query
    query_params = Rack::Utils.parse_nested_query(query_params_str)

    parse_query_params(query_params: query_params)
  end

  def self.parse_query_params(query_params:)
    _, ctx = Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Url::Parser::Fields.method(:parse_fields),
        Kit::Api::JsonApi::Services::Url::Parser::Sort.method(:parse_sort),
        Kit::Api::JsonApi::Services::Url::Parser::Include.method(:parse_include),
        Kit::Api::JsonApi::Services::Url::Parser::Filter.method(:parse_filter),
        Kit::Api::JsonApi::Services::Url::Parser::Page.method(:parse_page),
      ],
      ctx:  {
        query_params_in:  query_params.deep_symbolize_keys,
        query_params_out: {},
      },
    })

    [:ok, query_params: ctx[:query_params_out]]
  end

end
