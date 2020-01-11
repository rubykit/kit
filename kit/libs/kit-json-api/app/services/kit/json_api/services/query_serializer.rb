module Kit::JsonApi::Services::QuerySerializer

  def self.serialize_query_node(query_node:, parent_query_node: nil, current_relationship_name: nil, document: nil)
    if !document
      document ||= {
        cache:    {},
        included: {},
        response: {
          data:     [],
          included: [],
        }
      }
    end

    resource = query_node[:resource]
    type     = resource[:name]

    document[:cache][type] ||= {}

    query_node[:data].each do |data_element|
      formated_element = resource[:serializer].call(query_node: query_node, data_element: data_element)

      document[:cache][type] ||= {}
      document[:included][type] ||= {}

      id = formated_element[:id].to_s

      if (cached_document = document[:cache][type][id])
        cached_document.merge!(formated_element)
      else
        document[:cache][type][id] = formated_element
      end

      # Include the element it in the response
      if !document[:included][type][id]
        document[:included][type][id] = true
        document[:response][(parent_query_node ? :included : :data)] << formated_element
      end

      # Relationships: foreign key is on current object, we create the resource relationship in advance
      query_node[:relationships].each do |relationship_name, nested_query_node|
        # The foreign_key is on the parent, add relationship data now
        relationship = resource[:relationships][relationship_name]
        if relationship[:inclusion][:resolve_child]
          formated_element[:relationships] ||= {}
          container = formated_element[:relationships][relationship_name] ||= []
          child_element_type, child_element_id = relationship[:inclusion][:resolve_child].call(data_element: data_element)

          container << {
            data: {
              type: child_element_type,
              id:   child_element_id,
            }
          }
        end
      end

      # Solve relationships where the foreign_key is on the child, so the parent needs to be extended
      if current_relationship_name
        current_relationship = parent_query_node[:resource][:relationships][current_relationship_name]
        if current_relationship[:inclusion][:resolve_parent]
          parent_element_type, parent_element_id = current_relationship[:inclusion][:resolve_parent].call(data_element: data_element)

          parent_element = document[:cache][parent_element_type][parent_element_id.to_s]

          parent_element[:relationships] ||= {}
          container = parent_element[:relationships][current_relationship_name] ||= []

          container << {
            data: {
              type: type,
              id:   id,
            }
          }
        end
      end
    end

    query_node[:relationships].each do |relationship_name, nested_query_node|
      status, ctx = result = serialize_query_node(
        query_node:                nested_query_node,
        parent_query_node:         query_node,
        current_relationship_name: relationship_name,
        document:                  document,
      )
    end

    [:ok, document: document]
  end

  def self.serialize_response(document:)
    [:ok, json_str: Oj.dump(document, mode: :compat)]
  end

  def self.json_api_result_to_response(json_api_result_hash:, status: 200)
    string_content = Oj.dump(json_api_result_hash, mode: :compat)

    [:ok, {
      response: {
        mime:     :json_api,
        content:  json_api_result_hash,
        metadata: {
          http: {
            status: status,
          },
        },
      },
    }]
  end

end