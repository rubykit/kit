# @see https://jsonapi.org/format/1.1/#fetching-pagination
# @see https://jsonapi.org/extensions/##profiles-category-pagination
module Kit::Api::JsonApi::Services::Request::Pagination

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_pagination(config:, query_params:, request:)
    args = { config: config, query_params: query_params, request: request }

    Kit::Organizer.call({
      list: [
        self.method(:parse),
        self.method(:validate),
        self.method(:add_to_request),
      ],
      ctx:  args,
    })
  end

  # @see https://jsonapi.org/format/1.1/#fetching-pagination
  # @see https://jsonapi.org/profiles/ethanresnick/cursor-pagination/
  def self.parse(query_params:)
    data = query_params[:page] || {}
    list = {}

    data.each do |path, _val|
      path = path.to_s

      if path.include?('.')
        path, type = path.reverse.split('.', 2).map(&:reverse).reverse
      else
        type = path
        path = :top_level
      end
      type = type.to_sym

      list[path]        ||= {}
      (list[path][type] ||= []) << value
    end

    [:ok, parsed_query_params_page: list]
  end

  def self.validate(config:, parsed_query_params_page:)
    errors = []

    parsed_query_params_page.each do |path, list|
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

  def self.add_to_request(config:, parsed_query_params_page:, request:)
    request[:pages] = parsed_query_params_page

    [:ok, request: request]
  end

end
