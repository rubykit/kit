# A Resource is simply a module that defines certain methods to configure proper rendering of your JSONAPI documents.
# @todo: Make this the source of thruth instead of the Resource contracy?
module Kit::Api::JsonApi::Resources::Resource

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

    def links_single(record:)
      links = {
        self: resource_url(resource_id: record[:resource_object][:id]),
      }

      [:ok, links: links]
    end

    def links_collection(query_node:, records:)
      records_list = records

      links = {
        self: "https://top_level_collection-self_link?first=#{ records_list.first&.dig(:resource_object, :id) }&last=#{ records_list.last&.dig(:resource_object, :id) }",
        prev: '...',
        next: '...',
      }

      [:ok, links: links]
    end

    def links_relationship_single(record:, relationship:)
      records_list = record[:relationships][relationship[:name]]

      links = {
        self:    "https://to_one_rel-self_link?el=#{ records_list.first&.dig(:resource_object, :id) }",
        related: "https://to_one-relrelated_link?el=#{ records_list.first&.dig(:resource_object, :id) }",
      }

      [:ok, links: links]
    end

    def links_relationship_collection(record:, relationship:)
      records_list = record[:relationships][relationship[:name]]

      links = {
        self:    "https://to_many_rel-self_link?first=#{ records_list.first&.dig(:resource_object, :id) }&last=#{ records_list.last&.dig(:resource_object, :id) }",
        related: "https://to_many_rel-related_link?first=#{ records_list.first&.dig(:resource_object, :id) }&last=#{ records_list.last&.dig(:resource_object, :id) }",
      }

      [:ok, links: links]
    end

    #after Ct::Resource
    def resource
      @resource ||= Kit::Api::JsonApi::Types::Resource[{
        name:                          resource_name,

        fields:                        available_fields.keys,
        sort_fields:                   available_sort_fields,
        filters:                       available_filters,

        relationships:                 available_relationships,

        data_loader:                   self.method(:load_data),
        serializer:                    self.method(:serialize),

        links_single:                  self.method(:links_single),
        links_collection:              self.method(:links_collection),
        links_relationship_single:     self.method(:links_relationship_single),
        links_relationship_collection: self.method(:links_relationship_collection),
      }]
    end

    def available_fields
      raise 'Implement me.'
    end

    def available_sort_fields
      available_fields
        .map { |name, _| [name, { order: [[name, :asc]], default: (name == :id) }] }
        .to_h
    end

    def available_filters
      available_fields
        .map { |name, type| [name, Kit::Api::JsonApi::TypesHint.defaults[type]] }
        .to_h
    end

    def available_relationships
      raise 'Implement me.'
    end

    # `data_element` is whatever was added to data. This is opaque.
    def serialize(record:)
      raw_data   = record[:raw_data]
      query_node = record[:query_node]
      resource   = query_node[:resource]

      resource_object = {
        type:       resource[:name],
        id:         raw_data.id.to_s,
        attributes: raw_data.slice(resource[:fields] - [:id]),
      }

      [:ok, resource_object: resource_object]
    end

  end

end
