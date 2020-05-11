module Kit::JsonApiSpec::Resources::Chapter

  include Kit::Contract
  Ct = Kit::Api::JsonApi::Contracts

  include Kit::Api::JsonApi::Resources::Resource

  def self.resource_name
    :chapter
  end

  def self.resource_url(resource_id:)
    "/chapters/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/chapters/#{ resource_id }/relationships/#{ relationship_id }"
  end

  def self.available_fields
    {
      id:       Kit::Api::JsonApi::TypesHint::IdNumeric,
      title:    Kit::Api::JsonApi::TypesHint::String,
      ordering: Kit::Api::JsonApi::TypesHint::Numeric,
    }
  end

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Chapter::Relationships::Book,
    ]

    list
      .map { |el| [el.relationship[:name], el.relationship] }
      .to_h
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :chapter },
  ]
  def self.load_data(query_node:)
    model  = Kit::JsonApiSpec::Models::Write::Chapter
    _, ctx = Kit::Api::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA CHAPTER: #{ data.size }"

    [:ok, data: data]
  end

  def self.serialize(record:)
    query_node = record[:query_node]
    resource   = query_node[:resource]
    raw_data   = record[:raw_data]

    resource_object = {
      type:       resource[:name],
      id:         raw_data[:id].to_s,
      attributes: raw_data.slice(resource[:fields] - [:id, :ordering]).merge(ordering: raw_data[:index]),
    }

    [:ok, resource_object: resource_object]
  end

end
