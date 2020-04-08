# @ref https://jsonapi.org/format/1.1/#fetching-filtering
module Kit::JsonApi::Services::Request::Filtering
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.handle_sorting(config:, query_params:, request:)
    args = { config: config, query_params: query_params, request: request, }

    Kit::Organizer.call({
      list: [
        self.method(:validate_params),
        self.method(:add_to_request),
      ],
      ctx: args,
    })
  end

  def self.validate_params(config:, query_params:, request:)
    errors  = []

    query_params[:sort].each do |path, data|

      if path == :top_level
        resource = request[:top_level_resource]
      else
        resource = query_params[:related_resources][path]
      end

      if !resource
        errors << { detail: "Sort: `#{path}` is not an included relationship" }
        next
      end

      sign, sort_name = data

      sorter = resource[:sort_fields][sort_name.to_sym]
      if !sorter
        errors << { detail: "Sort: `#{path}.#{sort_name}` is not a valid sorting criteria" }
        next
      end

      # TODO: add restriction if only one order is valid.
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      [:ok]
    end
  end

  def self.add_to_request(config:, query_params:, request:)
    sorting = {}

    query_params[:sort].each do |path, data|
      sign, sort_name = data

      sorting[path] = data
    end

    request[:sorting] = sorting

    [:ok, request: request]
  end

end