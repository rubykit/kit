# ## Format
#
# The format to `include` related ressources is:
# ```kit-url
#  GET https://my.api/my-resource?include=relationship1,relationship2.nested_relationship
# ```
#
# ### ⚠️ Warning
#
# This need to be ran first to be able to validate filters, sorting, pagination & sparse fieldsets.
#
# ## References
# - https://jsonapi.org/format/1.1/#fetching-includes
#
module Kit::Api::JsonApi::Services::Request::RelatedResources

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  # Entry point. Parse & validate include data before adding it to the `Request`.
  def self.handle_related_resources(config:, query_params:, request:)
    args = { config: config, query_params: query_params, request: request }

    Kit::Organizer.call({
      list: [
        self.method(:parse),
        self.method(:validate_and_add_to_request),
      ],
      ctx:  args,
    })
  end

  # Extract `include` query params and transform it into a normalized hash.
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
  # {
  #   include: => ['books.author.books', 'series.books'],
  # }
  # ```
  def self.parse(query_params:)
    data = (query_params[:include] || '').split(',')

    [:ok, parsed_query_params_include: data]
  end

  # Ensures that nested relationships are valid.
  # When include data is valid, add it to the `Request`.
  def self.validate_and_add_to_request(config:, parsed_query_params_include:, request:)
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

        child_resource = relationship[:child_resource].call()

        related_resources[current_path.dup] = child_resource

        resource = child_resource
      end
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      request[:related_resources] = related_resources
      [:ok, request: request]
    end
  end

end
