# Logic to generate `include` query_params for links
module Kit::Api::JsonApi::Services::Request::Export::RelatedResources

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  # Export `included_paths` for a given path.
  #
  # ## Examples
  #
  # ```irb
  # irb> api_request[:related_resources]
  # {
  #   'books'              => BookResource,
  #   'books.author'       => AuthorResource,
  #   'books.author.books' => BookResource,
  #   'series'             => SerieResource,
  #   'series.books'       => BookResource,
  # }
  # irb> included_paths(api_request: api_request, path: 'books')
  # [ok, { included_paths: {
  #   path: 'books',
  #   list: {
  #     'books'              => BookResource,
  #     'books.author'       => AuthorResource,
  #     'books.author.books' => BookResource,
  #   },
  # }]
  # ```
  def self.included_paths(api_request:, path:)
    list = (api_request[:related_resources] || {})
      .select { |k, _v| k.to_s.start_with?(path) }

    [:ok, included_paths: {
      path: path,
      list: list,
    },]
  end

  # Export `include` query_params for `included_paths`.
  #
  # ## Examples
  #
  # ```irb
  # irb> api_request[:related_resources]
  # {
  #   'books'              => BookResource,
  #   'books.author'       => AuthorResource,
  #   'books.author.books' => BookResource,
  #   'series'             => SerieResource,
  #   'series.books'       => BookResource,
  # }
  # irb> included_paths
  # {
  #   path: 'books',
  #   list: {
  #     'books'              => BookResource,
  #     'books.author'       => AuthorResource,
  #     'books.author.books' => BookResource,
  #   },
  # }
  # irb> handle_related_resources(api_request: api_request, included_paths: included_paths)
  # [ok, { query_params: {
  #   include: 'author.books',
  # }]
  # ```
  def self.handle_related_resources(api_request:, query_params:, included_paths:)
    list = included_paths[:list]
    path = included_paths[:path]

    if list == { nil => nil }
      return [:ok, query_params: { include: '' }]
    end

    # Remove all paths that are included in another, starting by the longest ones.
    keys = list.keys.sort_by(&:length).reverse
    idx  = 0
    while idx < keys.size
      current = keys[idx]
      keys    = keys.reject { |k| current != k && current.include?(k) }
      idx    += 1
    end

    if keys.size > 0
      # Generate final string.
      path_size = (path.size > 0) ? (path.size + 1) : 0
      query_params[:include] = keys
        .map { |k| k[path_size..] }
        .sort
        .join(',')
    end

    [:ok, query_params: query_params]
  end

end
