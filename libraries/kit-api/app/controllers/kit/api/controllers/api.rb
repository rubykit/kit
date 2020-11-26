# Shared controller logic
module Kit::Api::Controllers::Api

  # Helper to generate a valid `Query` that's already resolved to a single object.
  #
  # Note: this is useful for edition actions.
  def self.generate_resolved_query(api_request:, resource:, model_instance:)
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
      api_request:   api_request,
    }

    query_node[:records][0][:query_node] = query_node

    [:ok, query_node: query_node]
  end

  def self.sanitize_writeable_parameters(template:, data:)
    result = {}

    template.each do |name, tpl_action|
      next if !data.key?(name)

      param_value = data[name]
      if tpl_action.is_a?(::Symbol)
        res = [tpl_action, param_value]
      else
        begin
          res = tpl_action.call(data: data, value: param_value)
        rescue
          # Generate error
        end
      end

      result[res[0]] = res[1]
    end

    [:ok, values: result]
  end

end
