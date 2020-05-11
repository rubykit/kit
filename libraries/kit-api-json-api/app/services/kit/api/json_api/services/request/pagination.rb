# @see https://jsonapi.org/format/1.1/#fetching-pagination
# @see https://jsonapi.org/extensions/##profiles-category-pagination
module Kit::Api::JsonApi::Services::Request::Pagination

  include Kit::Contract
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_pagination(config:, query_params:, request:)
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

    query_params[:page].each do |path, list|
      if path == :top_level
        resource = request[:top_level_resource]
      else
        resource = request[:related_resources][path]
      end

      if !resource
        errors << { detail: "Page: `#{ path }` is not an included relationship" }
      end

      list.each do |_attr_name, values|
        if values.size > 1
          error_path = (path == :top_level) ? name.to_s : "#{ path }.#{ name }"
          errors << { detail: "Page: `#{ error_path }` has multiple values" }
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
    request[:pages] = query_params[:page]

    [:ok, request: request]
  end

end
