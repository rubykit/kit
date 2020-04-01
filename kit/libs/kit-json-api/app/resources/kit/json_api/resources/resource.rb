module Kit::JsonApi::Resources::Resource
  extend ActiveSupport::Concern

  class_methods do
    def resource_name
      raise 'Implement me.'
    end

    def resource_url(resource_id:)
      raise 'Implement me.'
    end

    def relationship_url(resource_id:, relationship_name:)
      raise 'Implement me.'
    end

    #after Ct::Resource
    def resource
      @resource ||= Kit::JsonApi::Types::Resource[{
        name:                          resource_name,

        fields:                        available_fields.keys,
        sort_fields:                   available_sort_fields,
        filters:                       available_filters,

        relationships:                 available_relationships,

        data_loader:                   self.method(:load_data),
        serializer:                    self.method(:serialize),

        resource_links:                self.method(:resource_links),
        resource_collection_links:     self.method(:resource_collection_links),
        relationship_links:            self.method(:relationship_links),
        relationship_collection_links: self.method(:relationship_collection_links),
      }]
    end

    def available_fields
      raise 'Implement me.'
    end

    def available_sort_fields
      available_fields
        .map { |name, _| [name, { order: [[name, :asc]], default: (name == :id), }] }
        .to_h
    end

    def available_filters
      fields = available_fields
        .map { |name, type| [name, Kit::JsonApi::TypesHint.defaults[type]] }
        .to_h

      relationships = available_relationships
        .select { |_, rs| rs[:type] == :many }
        .map    { |name, _| [name, Kit::JsonApi::TypesHint.defaults[Kit::JsonApi::TypesHint::IdNumeric]] }
        .to_h

      fields.merge(relationships)
    end

    def available_relationships
      raise 'Implement me.'
   end

    def resource_links(serialized_element:)
      [:ok, {
        self: resource_url(resource_id: serialized_element[:id]),
      }]
    end

    # For collections there are 3 context elements:
    #  - Filters. They do not interact with the collection.
    #      For a top level collection, they are received in the request.
    #      For a relationship, they describe the foreign key.
    #  - Sorting. Always exist, but can be implicit.
    #  - Pagination. Depends on `sorting`. Contains the data that allows to select elements in a set. This needs to know the collection.
    def resource_collection_links(collection:, filters: nil, sorting:)
      [:ok, {
        self: '',
        prev: '', # RO
        next: '', # RO
        #first: '', # RO - Can be obtained for free
        #last:  '', # RO - Can we get this one? reversed sorting for the query + reversed data set
      }]
    end

    def relationship_links(data_element:, relationship:, filters: nil, sorting:)
      rs_resource = relationship[:resolve_resource].call()
      
      [:ok, {
        self:    relationship_url(resource_id: data_element[:id], relationship_name: relationship[:name]), # RS
        related: rs_resource[:resource_url].call(resource_id: data_element[:id]), # RO
      }]
    end

    def relationship_collection_links(data_element_collection:, relationship:, filters: nil, sorting:)
      relationship_url(relationship_name: relationship[:name])
      [:ok, {
        self:    '', # RS
        related: '', # RO
        #prev:    '', # RS not that interesting
        #next:    '', # RS not that interesting
      }]
    end

    # `data_element` is whatever was added to data. This is opaque.
    def serialize(data_element:, query_node:)
      resource = query_node[:resource]

      serialized_element = {
        type:       resource[:name],
        id:         data_element.id.to_s,
        attributes: data_element.slice(resource[:fields] - [:id]),
      }

      serialized_element[:links] = generate_resource_link(serialized_element: serialized_element)[1]

      [:ok, resource_object: serialized_element]
    end

  end
end