module Kit::JsonApi::Resources::Resource
  extend ActiveSupport::Concern

  class_methods do
    def resource_name
      raise 'Implement me.'
    end

    def resource_url(resource_id:)
      raise 'Implement me.'
    end

    def relationship_url(resource_id:, relationship_id:)
      raise 'Implement me.'
    end

    #after Ct::Resource
    def resource
      @resource ||= Kit::JsonApi::Types::Resource[{
        name:          resource_name,
        fields:        available_fields.keys,
        relationships: available_relationships,
        sort_fields:   available_sort_fields,
        filters:       available_filters,
        data_loader:   self.method(:load_data),
        serializer:    self.method(:serialize),
        links: {
          resource_object:     self.method(:generate_resource_link),
          resource_collection: self.method(:generate_collection_links),
          relationship:        self.method(:generate_relationships_links),
        },
      }]
    end

    def available_fields
      raise 'Implement me.'
    end

    def available_sort_fields
      raise 'Implement me.'
    end

    def available_filters
      fields_filters = available_fields
        .map { |name, type| [name, Kit::JsonApi::TypesHint.defaults[type]] }
        .to_h

      # @note Dummy filter, acts as an exemple
      filters = {
        alive: Kit::JsonApi::TypesHint.defaults[Kit::JsonApi::TypesHint::Boolean],
      }

      filters.merge(fields_filters)
    end

    def available_relationships
      raise 'Implement me.'
   end

    def generate_resource_link(serialized_element:)
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
    def generate_collection_links(resource_collection:, filters: nil, sorting:)
      [:ok, {
        self: '',
        prev: '', # RO
        next: '', # RO
        #first: '', # RO - Can be obtained for free
        #last:  '', # RO - Can we get this one? reversed sorting for the query + reversed data set
      }]
    end

    def generate_relationships_links(resource_collection:, filters: nil, sorting:)
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

      serialized_element
    end

  end
end