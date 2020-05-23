# Serializer entry point.
module Kit::Api::JsonApi::Services::Resolvers::Linker

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

=begin
  def self.links_single(record:)
    links = {
      self: resource_url(resource_id: record[:resource_object][:id]),
    }

    [:ok, links: links]
  end

  def self.links_collection(query_node:, records:)
    records_list = records

    links = {
      self: "https://top_level_collection-self_link?first=#{ records_list.first&.dig(:resource_object, :id) }&last=#{ records_list.last&.dig(:resource_object, :id) }",
      prev: '...',
      next: '...',
    }

    [:ok, links: links]
  end

  def self.links_relationship_single(record:, relationship:)
    records_list = record[:relationships][relationship[:name]]

    links = {
      self:    "https://to_one_rel-self_link?el=#{ records_list.first&.dig(:resource_object, :id) }",
      related: "https://to_one-relrelated_link?el=#{ records_list.first&.dig(:resource_object, :id) }",
    }

    [:ok, links: links]
  end

  def self.links_relationship_collection(record:, relationship:)
    records_list = record[:relationships][relationship[:name]]

    links = {
      self:    "https://to_many_rel-self_link?first=#{ records_list.first&.dig(:resource_object, :id) }&last=#{ records_list.last&.dig(:resource_object, :id) }",
      related: "https://to_many_rel-related_link?first=#{ records_list.first&.dig(:resource_object, :id) }&last=#{ records_list.last&.dig(:resource_object, :id) }",
    }

    [:ok, links: links]
  end
=end

end
