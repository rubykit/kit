# Resolve a Query: load data & map it
module Kit::JsonApi::Services::QueryResolver

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[query_node: Ct::QueryNode]
  after  Ct::Result[query_node: Ct::QueryNode]
  def self.resolve_query_node(query_node:)
    Kit::Organizer.call({
      list: [
        self.method(:resolve_query_node_condition),
        self.method(:load_records),
        self.method(:resolve_relationships_query_nodes),
        self.method(:resolve_relationships_records),
      ],
      ctx:  { query_node: query_node },
    })
  end

  before Ct::Hash[query_node: Ct::QueryNode]
  after  Ct::Result[query_node: Ct::QueryNode]
  def self.resolve_query_node_condition(query_node:)
    query_node[:condition] = resolve_condition(
      condition:  query_node[:condition],
      query_node: query_node,
    )

    [:ok, query_node: query_node]
  end

  def self.resolve_condition(condition:, query_node:)
    if condition.is_a?(Kit::JsonApi::Types::Condition)
      if condition[:op].in?([:or, :and])
        condition[:values] = condition[:values].map do |value|
          resolve_condition(condition: value, query_node: query_node)
        end
      end
    elsif condition.respond_to?(:call)
      condition = condition.call(query_node: query_node)
    end

    condition
  end

  before Ct::Hash[query_node: Ct::QueryNode]
  after  Ct::Result[query_node: Ct::QueryNode]
  def self.load_records(query_node:)
    result      = query_node[:data_loader].call(query_node: query_node)
    status, ctx = result

    if status == :ok
      query_node[:records] = ctx[:data].map do |raw_data|
        Kit::JsonApi::Types::Record[
          query_node:    query_node,
          raw_data:      raw_data,
          meta:          {},
          relationships: {},
        ]
      end

      [:ok, query_node: query_node]
    else
      result
    end
  end

  before Ct::Hash[query_node: Ct::QueryNode]
  after  Ct::Result[query_node: Ct::QueryNode]
  def self.resolve_relationships_query_nodes(query_node:)
    query_node[:relationships].each do |_relationship_name, relationship|
      nested_query_node = relationship[:child_query_node]
      result            = resolve_query_node(query_node: nested_query_node)
      status, _ctx      = result

      if status == [:error]
        return result
      end
    end

    [:ok, query_node: query_node]
  end

  def self.resolve_relationships_records(query_node:)
    query_node[:relationships].each do |relationship_name, relationship|
      child_query_node = relationship[:child_query_node]
      child_records    = child_query_node[:records]

      query_node[:records].each do |parent_record|
        selector = relationship[:select_relationship_record].call(parent_record: parent_record)
        parent_record[:relationships][relationship_name] = child_records.select(&selector)
      end
    end

    [:ok, query_node: query_node]
  end

end
