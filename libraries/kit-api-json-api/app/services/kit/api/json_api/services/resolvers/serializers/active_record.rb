# ActiveRecord data resolver.
module Kit::Api::JsonApi::Services::Resolvers::Serializers::ActiveRecord

  # Generate the serialized version of a Record
  # `raw_data` is whatever was added to data, in this case, the ActiveRecord Model instance that was retrieved.
  def self.record_serializer(record:)
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