# Serialization logic for Relatiobships
module Kit::Api::JsonApi::Services::Serializer::Relationship

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  before Ct::Hash[document: Ct::Document, record: Ct::Record, relationship: Ct::Relationship]
  after  Ct::Result[document: Ct::Document]
  def self.serialize_record_relationship(document:, record:, relationship:)
    Kit::Organizer.call({
      list: [
        self.method(:get_relationship_pathname),
        self.method(:get_document_relationship_container),
        self.method(:add_record_relationship_linkage),
        self.method(:add_record_relationship_links),
      ],
      ctx:  {
        document:     document,
        record:       record,
        relationship: relationship,
      },
    })

    [:ok, document: document]
  end

  # Get full relationship pathname to avoid collisions on collections that are loaded through different paths.
  def self.get_relationship_pathname(relationship:)
    relationship_pathname = relationship[:name].to_s

    while (relationship = relationship[:parent_query_node][:parent_relationship]) do
      relationship_pathname = "#{ relationship[:name] }.#{ relationship_pathname }"
    end

    [:ok, relationship_pathname: relationship_pathname]
  end

  def self.get_document_relationship_container(document:, record:, relationship:, relationship_pathname:)
    resource_object = record[:resource_object]

    # to_one relationships can not generate collision so no need for the full pathname
    if relationship[:type] == :to_one
      relationship_pathname = relationship[:name].to_s
    end

    resource_object[:relationships] ||= {}

    relationship_container = resource_object[:relationships][relationship_pathname] ||= {
      data:  [],
      links: {},
    }

    [:ok, document: document, relationship_container: relationship_container]
  end

  def self.add_record_relationship_linkage(document:, record:, relationship:, relationship_container:)
    relationship_records = record[:relationships][relationship[:name]]

    relationship_records.each do |relationship_record|
      linkage_data = {
        type: relationship_record[:query_node][:resource][:name],
        id:   relationship_record[:resource_object][:id],
      }

      relationship_container[:data] << linkage_data
    end

    [:ok, document: document]
  end

  def self.add_record_relationship_links(document:, record:, relationship:, relationship_container:)
    resource = record[:query_node][:resource]

    if relationship[:type] == :to_one
      links = resource[:links_relationship_single].call(record: record, relationship: relationship)[1][:links]
    else
      links = resource[:links_relationship_collection].call(record: record, relationship: relationship)[1][:links]
    end

    # NOTE: not sure this is needed / links can change anyway
    relationship_container[:links].deep_merge!(links)

    [:ok, document: document]
  end

end
