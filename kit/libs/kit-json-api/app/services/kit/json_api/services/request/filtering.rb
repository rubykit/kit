# @ref https://jsonapi.org/format/1.1/#fetching-filtering
module Kit::JsonApi::Services::Request::Filtering
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.handle_filtering(config:, query_params:, request:)
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

    query_params[:filter].each do |path, list|
      if path == :top_level
        resource = request[:top_level_resource]
      else
        resource = request[:related_resources][path]
      end

      if !resource
        errors << { detail: "Filter: `#{path}` is not an included relationship" }
        next
      end

      list.each do |name:, op:, value:|
        operators  = resource[:filters][name.to_sym]
        error_path = (path == :top_level) ? "#{name}" : "#{path}.#{name}"

        if !operators
          errors << { detail: "Filter: `#{error_path}` is not a valid filter" }
        elsif !op.in?(operators)
          errors << { detail: "Filter: `#{error_path}` does not support operator `#{op}`" }
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
    request[:filters] = query_params[:filter]

    [:ok, request: request]
  end

end