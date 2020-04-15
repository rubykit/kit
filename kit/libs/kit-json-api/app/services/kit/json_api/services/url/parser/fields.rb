# Transform the `fields` query parameter into something usable.
module Kit::JsonApi::Services::Url::Parser::Fields

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  # @ex GET /authors?fields[authors]=name,date_of_birth&fields[books]=title
  # @ref https://jsonapi.org/format/1.1/#fetching-sparse-fieldsets
  def self.parse_fields(query_params_in:, query_params_out:)
    list = {}
    data = query_params_in[:fields] || {}

    data.each do |type_name, fields|
      list[type_name] = fields.split(',').map(&:to_sym)
    end

    query_params_out[:fields] = list

    [:ok, query_params_out: query_params_out]
  end

end
