# @see https://jsonapi.org/format/1.1/#fetching-sorting
module Kit::Api::JsonApi::Services::Request::Sorting

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_sorting(config:, query_params:, request:)
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

  # For the given example, the following sorting is applied: { authors: [name DESC, date_of_birt ASC], books: [date_published ASC, title DESC] }
  # @example GET /authors?sort=-name,books.date_published,date_of_birth,-books.title
  # @see https://jsonapi.org/format/1.1/#fetching-sorting
  def self.parse(query_params:)
    data = (query_params[:sort] || '').split(',')
    list = {}

    data.each do |sid|
      if sid[0] == '-' || sid[0] == '+'
        sign = sid[0]
        sid  = sid[1..-1]
      else
        sign = '+'
      end

      direction = (sign == '+') ? :asc : :desc

      if sid.include?('.')
        path, sid = sid.reverse.split('.', 2).map(&:reverse).reverse
      else
        path = :top_level
      end

      list[path] ||= []
      list[path] << { direction: direction, sort_name: sid.to_sym }
    end

    [:ok, parsed_query_params_sort: list]
  end

  def self.validate(config:, parsed_query_params_sort:, request:)
    errors = []

    parsed_query_params_sort.each do |path, list|
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

  def self.add_to_request(config:, parsed_query_params_sort:, request:)
    request[:sorting] = parsed_query_params_sort

    [:ok, request: request]
  end

end
