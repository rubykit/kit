# Holds the query_parameters validation logic for the Cursor paginator.
#
# TODO: good candidate to rewrite as Contracts.
module Kit::Api::JsonApi::Services::Paginators::Cursor::Validation

  def self.validate(api_request:, parsed_query_params_page:)
    args = { api_request: api_request, parsed_query_params_page: parsed_query_params_page }

    Kit::Organizer.call({
      list: [
        self.method(:validate_keys),
        self.method(:ensure_single_value),
        self.method(:validate_size_parameters),
        self.method(:ensure_no_nesting),
        self.method(:decrypt_cursors),
      ],
      ctx:  args,
    })
  end

  # Only accepts `:size`, `:after`, `:before` keywords
  def self.validate_keys(parsed_query_params_page:)
    parsed_query_params_page.map do |path, list|
      list.each do |key, _value|
        if ![:size, :after, :before].include?(key)
          return Kit::Error(error(str: "unsupported keyword `#{ key }` in `page[$path_prefix#{ key }]`", path: path))
        end
      end
    end

    [:ok]
  end

  # Only accept single value as query_parameter, not lists.
  def self.ensure_single_value(parsed_query_params_page:)
    parsed_query_params_page.map do |path, list|
      list.each do |key, value|
        if value.is_a?(Array) && value.size > 1
          return Kit::Error(error(str: "multiple values for `page[$path_prefix#{ key }]`", path: path))
        end
      end
    end

    [:ok]
  end

  # Validate `:size` parameters.
  def self.validate_size_parameters(api_request:, parsed_query_params_page:)
    config        = api_request[:config]
    page_size_max = config[:page_size_max]

    parsed_query_params_page.map do |path, list|
      size = list.dig(:size, 0)
      next if !size

      size_int = size.to_i
      if size_int <= 0
        return Kit::Error(error(str: "invalid value `#{ size }` for `page[$path_prefixsize]`", path: path))
      end

      if size_int > page_size_max
        return Kit::Error(error(str: "invalid value `#{ size }` for `page[$path_prefixsize]`. The API maximum page size is: #{ page_size_max }", path: path))
      end

      list[:size] = size_int
    end

    [:ok]
  end

  # Decrypt `:after` && `:before` cursors if present.
  def self.decrypt_cursors(api_request:, parsed_query_params_page:)
    config = api_request[:config]

    parsed_query_params_page.map do |path, list|
      [:after, :before].each do |key|
        next if !list.key?(key)

        value = list.dig(key, 0)

        if value
          status, ctx = Kit::Api::Services::Encryption.decrypt(
            encrypted_data: value,
            key:            config[:meta][:kit_api_paginator_cursor][:encrypt_secret],
          )
        end

        if !status || status == :error
          return Kit::Error(error(str: "invalid cursor for `page[$path_prefix#{ key }]`", path: path))
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
  def self.ensure_no_nesting(api_request:, parsed_query_params_page:)
    config = api_request[:config]

    parsed_query_params_page.map do |path, _list|
      level    = (api_request[:singular] == false) ? 1 : 0
      resource = api_request[:top_level_resource]

      (path == :top_level ? '' : path).split('.').each do |name|
        relationship = resource[:relationships][name.to_sym]
        level       += (relationship[:relationship_type] == :to_many) ? 1 : 0

        if level > 1 && (parsed_query_params_page[path][:before] || parsed_query_params_page[path][:after])
          return Kit::Error(error(str: "can not use cursor pagination on path `#{ path }`"))
        end

        resource = config[:resources][relationship[:resource]]
      end
    end

    [:ok]
  end

  # Simple error formatting.
  def self.error(str:, path: nil)
    if path
      path_prefix = (path != :top_level && path.to_s.size > 0) ? "#{ path }." : ''
      str         = str.gsub('$path_prefix', path_prefix)
    end

    "Pagination error: #{ str }"
  end

end
