# `JSON:API` allows endpoint to return only specific fields in a response.
#
# **⚠️ Warning**: this is done on a per-type (`Resource`) basis, not on a per-relationship.
#
# ## URL format
#
# The format for sparse fieldsets is:
# ```kit-url
#  GET https://my.api/my-resource?fields[resource]=field1,field2
# ```
#
# ## References
# - https://jsonapi.org/format/1.1/#fetching-sparse-fieldsets
#
module Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  # Entry point. Parse & validate sparse-fieldsets data before adding it to the `Request`.
  def self.handle_sparse_fieldsets(query_params:, api_request:)
    args = { query_params: query_params, api_request: api_request }

    Kit::Organizer.call(
      list: [
        self.method(:parse),
        self.method(:validate_params),
        self.method(:add_to_api_request),
      ],
      ctx:  args,
    )
  end

  # Extract `fields` query params and transform it into a normalized hash.
  #
  # ## Examples
  #
  # ```irb
  # irb> ex_qp  = "fields[author]=name,date_of_birth&fields[book]=title"
  # irb> _, ctx = Services::Url.parse_query_params(url: "scheme://my.api/my-resource?#{ ex_qp }")
  # irb> ctx[:query_params]
  # {
  #   fields: {
  #     author: 'name,date_of_birth',
  #     book:   'title',
  #   },
  # }
  # irb> _, ctx = parse(query_params: ctx[:query_params])
  # irb> ctx[:parsed_query_params_fields]
  # {
  #   author: ['name', 'date_of_birth'],
  #   book:   ['title'],
  # }
  # ```
  def self.parse(query_params:)
    list = {}
    data = query_params[:fields] || {}

    data.each do |type_name, fields|
      list[type_name] = fields.split(',').map(&:to_sym)
    end

    [:ok, parsed_query_params_fields: list]
  end

  # Ensures that:
  # - types (`Resources`) exist
  # - fields exist
  def self.validate_params(api_request:, parsed_query_params_fields:)
    config = api_request[:config]
    errors = []

    parsed_query_params_fields.each do |type_name, fields|
      resource = config[:resources][type_name]

      if resource
        fields.each do |field_name|
          if !resource[:fields].include?(field_name)
            errors << { detail: "Sparse fieldsets: `#{ type_name }`.`#{ field_name }` is not an available field" }
          end
        end
      else
        errors << { detail: "Sparse fieldsets: `#{ type_name }` is not an available type" }
      end
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      [:ok]
    end
  end

  # When sparse fieldsets data is valid, add it to the `Request`.
  def self.add_to_api_request(api_request:, parsed_query_params_fields:)
    api_request[:fields] = parsed_query_params_fields

    [:ok, api_request: api_request]
  end

end
