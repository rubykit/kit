# @see https://jsonapi.org/format/1.1/#fetching-sorting
module Kit::JsonApi::Services::Request::Sorting

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.handle_sorting(config:, query_params:, request:)
    args = { config: config, query_params: query_params, request: request }

    Kit::Organizer.call({
      list: [
        self.method(:validate_params),
        self.method(:add_to_request),
      ],
      ctx:  args,
    })
  end

  def self.validate_params(config:, query_params:, request:)
    errors = []

    query_params[:sort].each do |path, list|
      if path == :top_level
        resource = request[:top_level_resource]
      else
        resource = request[:related_resources][path]
      end

      if !resource
        errors << { detail: "Sort: `#{ path }` is not an included relationship" }
        next
      end

      list.each do |direction:, sort_name:|
        sorter = resource[:sort_fields][sort_name.to_sym]
        if !sorter
          if path == :top_level
            detail = "Sort: `#{ sort_name }` is not a valid sorting criteria"
          else
            detail = "Sort: `#{ path }.#{ sort_name }` is not a valid sorting criteria"
          end
          errors << { detail: detail }
        end
      end

      # TODO: add restriction if only one order is valid?
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      [:ok]
    end
  end

  def self.add_to_request(config:, query_params:, request:)
    request[:sorting] = query_params[:sort]

    [:ok, request: request]
  end

end
