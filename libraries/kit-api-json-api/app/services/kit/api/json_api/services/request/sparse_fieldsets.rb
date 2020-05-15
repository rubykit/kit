# @see https://jsonapi.org/format/1.1/#fetching-sparse-fieldsets
module Kit::Api::JsonApi::Services::Request::SparseFieldsets

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_sparse_fieldsets(config:, query_params:, request:)
    args = { config: config, query_params: query_params, request: request }

    Kit::Organizer.call({
      list: [
        self.method(:parse),
        self.method(:validate_params),
        self.method(:add_to_request),
      ],
      ctx:  args,
    })
  end

  # @example GET /authors?fields[authors]=name,date_of_birth&fields[books]=title
  # @see https://jsonapi.org/format/1.1/#fetching-sparse-fieldsets
  def self.parse(query_params:)
    list = {}
    data = query_params[:fields] || {}

    data.each do |type_name, fields|
      list[type_name] = fields.split(',').map(&:to_sym)
    end

    [:ok, parsed_query_params_fields: list]
  end

  def self.validate_params(config:, parsed_query_params_fields:)
    errors = []

    parsed_query_params_fields.each do |type_name, fields|
      resource = config[:resources][type_name]

      if !resource
        errors << { detail: "Sparse fieldsets: `#{ type_name }` is not an available type" }
      else
        fields.each do |field_name|
          if !resource[:fields].include?(field_name)
            errors << { detail: "Sparse fieldsets: `#{ type_name }`.`#{ field_name }` is not an available field" }
          end
        end
      end
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      [:ok]
    end
  end

  def self.add_to_request(config:, parsed_query_params_fields:, request:)
    request[:fields] = parsed_query_params_fields

    [:ok, request: request]
  end

end
