require 'uri'
#require 'Rack'

module Kit::JsonApi::Services::Url::Parser
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.parse_url(url:)
    query_params_str = URI(url).query
    query_params     = Rack::Utils::parse_nested_query(query_params_str)

    parse_query_params(query_params: query_params)
  end

  def self.parse_query_params(query_params:)
    status, ctx = Kit::Organizer.call({
      list: [
        Kit::JsonApi::Services::Url::Parser::Fields.method(:parse_fields),
        Kit::JsonApi::Services::Url::Parser::Sort.method(:parse_sort),
        Kit::JsonApi::Services::Url::Parser::Include.method(:parse_include),
        Kit::JsonApi::Services::Url::Parser::Filter.method(:parse_filter),
        Kit::JsonApi::Services::Url::Parser::Page.method(:parse_page),
      ],
      ctx: {
        query_params_in:  query_params.deep_symbolize_keys,
        query_params_out: {},
      },
    })

    [:ok, query_params: ctx[:query_params_out]]
  end

end