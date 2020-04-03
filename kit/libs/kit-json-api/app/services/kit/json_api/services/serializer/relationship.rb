module Kit::JsonApi::Services::Serializer::Relationship
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[document: Ct::Document, record: Ct::Record, relationship: Ct::Relationship]
  after  Ct::Result[document: Ct::Document]
  def self.serialize_record_relationship(document:, record:, relationship:)
    status, ctx = Kit::Organizer.call({
      list: [
        self.method(:get_relationship_pathname),
        self.method(:get_document_relationship_container),
        self.method(:add_record_relationship_linkage),
        self.method(:add_record_relationship_links),
      ],
      ctx: {
        document:     document,
        record:       record,
        relationship: relationship,
      },
    })

    [:ok, document: document]
  end

  # Get full relationship pathname to avoid collisions on collections that are loaded through different paths.
  def self.get_relationship_pathname(relationship:)
    relationship_pathname = relationship[:name]

    if relationship[:type] == :many
      while (relationship = relationship[:parent_query_node][:parent_relationship]) do
        relationship_pathname = "#{relationship[:name]}.#{relationship_pathname}"
      end
    end

    [:ok, relationship_pathname: relationship_pathname]
  end

  def self.get_document_relationship_container(document:, record:, relationship_pathname:)
    resource_object        = record[:resource_object]

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
      relationship_container[:links] = resource[:links_relationship_single].call(record: record, relationship: relationship,)[1][:links]
    else
      relationship_container[:links] = resource[:links_relationship_collection].call(record: record, relationship: relationship,)[1][:links]
    end

    [:ok, document: document]
  end

end