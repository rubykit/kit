# Shared controller logic
module Kit::Api::Controllers::Api

  # Helper to generate a valid `Query` that's already resolved to a single object.
  #
  # Note: this is useful for edition actions.
  def self.generate_resolved_query(api_request:, model_instance:)
    resource   = api_request[:top_level_resource]

    query_node = {
      path:          '',
      condition:     nil,
      sorting:       [[:id, :asc]],
      resource:      resource,
      limit:         1,
      records:       [
        {
          raw_data:      model_instance,
          relationships: {},
        },
      ],
      resolvers:     { data_resolver: resource[:data_resolver] },
      relationships: {},
      singular:      api_request[:singular],
      api_request:   api_request,
    }

    query_node[:records][0][:query_node] = query_node

    [:ok, query_node: query_node]
  end

  def self.sanitize_writeable_attributes(template:, data:)
    result = {}

    template.each do |attr_name, attr_properties|
      next if !data.key?(attr_name)

      begin
        attr_value = attr_properties[:parse].call(
          data:  data,
          value: data[attr_name],
        )
      rescue StandardError => _e
        # TODO: notice `_e` ?
        return [:error, {
          detail:    "Could not parse attribute `#{ attr_name }`",
          attribute: attr_name,
          json_api:  {
            pointer: "data/attributes/#{ attr_name }",
          },
        },]
      end

      result[attr_properties[:field]] = attr_value
    end

    [:ok, model_attributes: result]
  end

  def self.sanitize_writeable_relationships(template:, data:)
    result = {}

    template.each do |relationship_name, relationship_data|
      attr_rs_value = data.dig(relationship_name.to_s, :data.to_s)
      next if !attr_rs_value

      if attr_rs_value['type'] == relationship_data[:type].to_s
        result[relationship_data[:field]] = attr_rs_value['id']
      else
        return [:error, { detail: "Invalid relationship type. Expected `#{ relationship_data[:type] }`, got `#{ attr_rs_value['type'] }`" }]
      end
    end

    [:ok, model_attributes: result]
  end

end
