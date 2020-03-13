module Kit::JsonApi::Services::Serializer::Query
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[query_node: Ct::QueryNode]
  after  Ct::Result[document: Ct::Document]
  # Entry point to serialize a query AST
  def self.serialize_query(query_node:)
    Kit::Organizer.call({
      list: [
        self.method(:create_document),
        Kit::JsonApi::Services::Serializer::QueryNode.method(:serialize_query_node),
      ],
      ctx: { query_node: query_node, },
    })
  end

  after  Ct::Result[document: Ct::Document]
  # Create a Document object that contains the json response and various caches
  def self.create_document
    document = Kit::JsonApi::Types::Document[{
      cache:    {
        resource_objects: {},
        data_elements: {}
      },
      included: {},
      response: {
        data:     [],
        included: [],
      },
    }]

    [:ok, document: document]
  end

end