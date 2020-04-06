# @ref https://jsonapi.org/format/1.1/#fetching-includes
module Kit::JsonApi::Services::Request::RelatedResources
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.handle_related_resources(config:, query_params:, request:)
    args = { config: config, query_params: query_params, request: request, }

    Kit::Organizer.call({
      list: [
        self.method(:validate_params),
      ],
      ctx: args,
    })
  end

  def self.validate_params(config:, query_params:, request:)
    errors = []
    top_level_resource = request[:top_level_resource]
    related_resources  = {}

    query_params[:include].each do |path|
      resource     = top_level_resource
      current_path = ''

      path.split('.').map(&:to_sym).each do |relationship_name|
        relationship = resource[:relationships][relationship_name]
        current_path = "#{ current_path }#{ current_path.size > 0 ? '.' : '' }#{ relationship_name }"

        if !relationship
          errors << { detail: "Related resource: `#{current_path}` is not a valid relationship" }
          break
        end

        related_resources[current_path.dup] = true

        resource = relationship[:child_resource].call()
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