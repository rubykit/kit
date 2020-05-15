# Serialization logic for ResourceObjects
module Kit::Api::JsonApi::Services::Serializer::ResourceObject

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  before Ct::Hash[document: Ct::Document, record: Ct::Record]
  after  Ct::Result[document: Ct::Document]
  # Serializes a single `resource_object`. Handles relationship resource linkage.
  def self.serialize_resource_object(document:, record:)
    _, ctx = Kit::Organizer.call({
      list: [
        record[:query_node][:resource][:serializer],
        self.method(:add_record_to_cache),
        self.method(:ensure_uniqueness_in_document),
        self.method(:add_resource_object_links),
      ],
      ctx:  {
        document: document,
        record:   record,
      },
    })

    [:ok, ctx.slice(:document, :record)]
  end

  # Add the resource_object to document cache.
  # Extend the resource_object if it already exists (loaded through different relationships).
  # TODO: split this into multiple actions?
  def self.add_record_to_cache(document:, record:, resource_object:)
    query_node = record[:query_node]

    type       = query_node[:resource][:name]
    id         = resource_object[:id].to_s
    ro_cache   = document[:cache][:resource_objects][type][id] ||= { resource_object: nil, records: {}, relationships: {} }

    if (cached_resourced_object = ro_cache[:resource_object])
      # NOTE: careful to keep the same reference / object_id
      resource_object = cached_resourced_object.deep_merge!(resource_object)
    end
    ro_cache[:resource_object] = resource_object

    record[:resource_object]   = resource_object

    ro_cache[:records][record.object_id] = true

    [:ok, document: document, record: record, resource_object: resource_object]
  end

  # Ensures the resource_object is only included in the response once, per specs.
  def self.ensure_uniqueness_in_document(document:, record:)
    query_node      = record[:query_node]
    resource_object = record[:resource_object]

    type            = query_node[:resource][:name]
    id              = resource_object[:id].to_s

    # Include the element in the response only once.
    if !document[:included][type][id]
      document[:included][type][id] = true

      is_top_level = !query_node[:parent_relationship]
      document[:response][(is_top_level ? :data : :included)] << resource_object
    end

    [:ok, document: document]
  end

  def self.add_resource_object_links(record:)
    resource = record[:query_node][:resource]

    record[:resource_object][:links] = resource[:links_single].call(record: record)[1][:links]

    [:ok, record: record]
  end

end
