# @ref https://jsonapi.org/format/1.1/#fetching-sparse-fieldsets
module Kit::JsonApi::Services::Request::SparseFieldsets

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.handle_sparse_fieldsets(config:, query_params:, request:)
    args = { config: config, query_params: query_params, request: request }

    Kit::Organizer.call({
      list: [
        self.method(:validate_params),
        self.method(:add_to_request),
      ],
      ctx:  args,
    })
  end

  def self.validate_params(config:, query_params:)
    errors = []

    query_params[:fields].each do |type_name, fields|
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

  def self.add_to_request(config:, query_params:, request:)
    request[:fields] = query_params[:fields]

    [:ok, request: request]
  end

end
