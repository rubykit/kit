# Holds the query_parameters validation logic for the Cursor paginator.
#
# TODO: good candidate to rewrite as Contracts.
module Kit::Api::JsonApi::Services::Paginators::Cursor::Validation

  def self.validate(request:, parsed_query_params_page:)
    args = { request: request, parsed_query_params_page: parsed_query_params_page }

    Kit::Organizer.call({
      list: [
        self.method(:validate_keys),
        self.method(:ensure_single_value),
        self.method(:validate_size_parameters_type),
        self.method(:validate_after_before_parameters_type),
        self.method(:decrypt_cursors),
        self.method(:ensure_no_nesting),
      ],
      ctx:  args,
    })
  end

  # Only accepts `:size`, `:after`, `:before` keywords
  def self.validate_keys(parsed_query_params_page:)
    parsed_query_params_page.map do |path, list|
      list.each do |key, _value|
        if ![:size, :after, :before].include?(key)
          return Kit::Error(error(str: "Unsupported keyword `#{ key }` in `page[$path_prefix#{ key }]`", path: path))
        end
      end
    end

    [:ok]
  end

  # Only accept single value as query_parameter, not lists.
  def self.ensure_single_value(parsed_query_params_page:)
    parsed_query_params_page.map do |path, list|
      list.each do |_key, value|
        if value.is_a?(Array) && value.size > 1
          return Kit::Error(error(str: "Multiple values for `page[$path_prefix#{ key }]`", path: path))
        end
      end
    end

    [:ok]
  end

  # Validate `:size` parameters.
  def self.validate_size_parameters(request:, parsed_query_params_page:)
    config        = request[:config]
    max_page_size = config[:max_page_size]

    parsed_query_params_page.map do |path, list|
      next if !list[:size]

      list[:size] = list[:size].to_i
      if list[:size] < 0
        return Kit::Error(error(str: "Invalid value `#{ list[:size] }` for `page[$path_prefix#{ key }]`", path: path))
      end

      if list[:size] > max_page_size
        return Kit::Error(error(str: "Invalid value `#{ list[:size] }` for `page[$path_prefix#{ key }]`. The API maximum page size is: #{ max_page_size }", path: path))
      end
    end

    [:ok]
  end

  # Ensure `:after` && `:before` are String if present.
  def self.validate_after_before_parameters_type(parsed_query_params_page:)
    parsed_query_params_page.map do |path, list|
      [:after, :before].each do |key|
        value = list[key]
        if value && !value.is_a?(String)
          return Kit::Error(error(str: "Invalid cursor for `page[$path_prefix#{ key }]`", path: path))
        end
      end
    end

    [:ok]
  end

  # Decrypt `:after` && `:before` cursors if present.
  def self.decrypt_cursors(request:, parsed_query_params_page:)
    config = request[:config]

    parsed_query_params_page.map do |path, list|
      [:after, :before].each do |key|
        status, ctx = Kit::Api::JsonApi::Services::Crypt.decrypt_object(
          encrypted_data: value,
          key:            config[:meta][:kit_api_paginator_cursor][:encrypt_secret],
        )

        if status == :error
          return Kit::Error(error(str: "Invalid cursor for `page[$path_prefix#{ key }]`", path: path))
        end

        list[key] = ctx[:data]
      end
    end

    [:ok, parsed_query_params_page: parsed_query_params_page]
  end

  # Detect nested pagination (pagination that targets a nested to_many).
  #
  # This is probably never what API developers want because the a cursor only target one subset.
  # See `Nested pagination` in the module doc.
  #
  # Traverse every request path and count the collection nesting level. If > 1, not paginateable.
  def self.ensure_no_nesting(request:, parsed_query_params_page:)
    config = request[:config]

    parsed_query_params_page.map do |path, _list|
      level    = (request[:singular] == false) ? 1 : 0
      resource = request[:top_level_resource]

      path.split('.').each do |name|
        relationship = config[:resources][resource[:relationships][name]]
        level       += (relationship[:relationship_type] == :to_many) ? 1 : 0

        if level > 1 && (parsed_query_params_page[path][:before] || parsed_query_params_page[path][:after])
          return Kit::Error(error(str: "Can not use cursor pagination on path `#{ path }`"))
        end

        resource = config[:resources][relationship[:resource]]
      end
    end

    [:ok]
  end

  # Simple error formatting.
  def self.error(str:, path: nil)
    if path
      path_prefix = path.size > 0 ? "#{ path }." : ''
      str         = str.gsub('$path_prefix', path_prefix)
    end

    "Pagination error: #{ str }"
  end

end
