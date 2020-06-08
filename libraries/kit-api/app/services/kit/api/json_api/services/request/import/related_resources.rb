# ## URL format
#
# The format to include related ressources is:
# ```kit-url
#  GET https://my.api/my-resource?include=relationship1,relationship2.nested_relationship
# ```
#
# ### ⚠️ Warning
#
# Filtering, Sorting & Pagination potentially depend on `include` if they describe related resources, so this need to be ran first.
#
# ## References
# - https://jsonapi.org/format/1.1/#fetching-includes
#
module Kit::Api::JsonApi::Services::Request::Import::RelatedResources

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  # Entry point. Parse & validate include data before adding it to the `Request`.
  def self.handle_related_resources(query_params:, request:)
    args = { query_params: query_params, request: request }

    Kit::Organizer.call({
      list: [
        self.method(:parse),
        self.method(:validate_and_parse),
        self.method(:add_to_request),
      ],
      ctx:  args,
    })
  end

  # Extract `include` query-param and transform it into a normalized array.
  #
  # ## Examples
  #
  # ```irb
  # irb> ex_qp  = 'author?include=books.author.books,series.books'
  # irb> _, ctx = Services::Url.parse_query_params(url: "scheme://my.api/my-resource?#{ ex_qp }")
  # irb> ctx[:query_params]
  # {
  #   include: 'books.author.books,series.books',
  # }
  # irb> _, ctx = parse(query_params: ctx[:query_params])
  # irb> ctx[:parsed_query_params_include]
  # ['books.author.books', 'series.books']
  # ```
  def self.parse(query_params:)
    data = (query_params[:include] || '').split(',')

    [:ok, parsed_query_params_include: data]
  end

  # Ensure that:
  #  - top level resource is valid
  #  - nested relationships are valid
  #
  # This resolve the Resource object for every path requested and replace `parsed_query_params_include` with a normalized hash.
  #
  # ## Examples
  #
  # ```irb
  # irb> parsed_query_params_include = ['books.author.books', 'series.books']
  # irb> _, ctx = validate_and_add_to_request(parsed_query_params_include: parsed_query_params_include)
  # irb> ctx[:parsed_query_params_include]
  # {
  #   'books'              => BookResource,
  #   'books.author'       => AuthorResource,
  #   'books.author.books' => BookResource,
  #   'series'             => SerieResource,
  #   'series.books'       => BookResource,
  # }
  # ```
  def self.validate_and_parse(parsed_query_params_include:, request:)
    config = request[:config]
    errors = []
    top_level_resource = request[:top_level_resource]
    related_resources  = {}

    parsed_query_params_include.each do |path|
      resource     = top_level_resource
      current_path = ''

      path.split('.').map(&:to_sym).each do |relationship_name|
        relationship = resource[:relationships][relationship_name]
        current_path = "#{ current_path }#{ current_path.size > 0 ? '.' : '' }#{ relationship_name }"

        if !relationship
          errors << { detail: "Related resource: `#{ current_path }` is not a valid relationship" }
          break
        end

        child_resource = config[:resources][relationship[:resource]]

        related_resources[current_path.dup] = child_resource

        resource = child_resource
      end
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      parsed_query_params_include = related_resources
      [:ok, parsed_query_params_include: parsed_query_params_include]
    end
  end

  # When inclusion data is valid, add it to the `Request`.
  def self.add_to_request(parsed_query_params_include:, request:)
    request[:related_resources] = parsed_query_params_include

    [:ok, request: request]
  end

end
