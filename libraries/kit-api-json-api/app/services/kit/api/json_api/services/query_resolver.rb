# Resolve a Query: load data & map it
module Kit::Api::JsonApi::Services::QueryResolver

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  before Ct::Hash[query_node: Ct::QueryNode]
  after  Ct::Result[query_node: Ct::QueryNode]
  def self.resolve_query_node(query_node:)
    puts "Resolving #{ query_node[:path] }" if ENV['KIT_API_DEBUG']

    Kit::Organizer.call({
      list: [
        self.method(:resolve_query_node_condition),
        self.method(:resolve_data),
        self.method(:resolve_relationships_query_nodes),
        self.method(:resolve_relationships_records),
      ],
      ctx:  { query_node: query_node, resolve: true },
    })
  end

  before Ct::Hash[query_node: Ct::QueryNode]
  after  Ct::Result[query_node: Ct::QueryNode]
  def self.resolve_query_node_condition(query_node:)
    if query_node[:condition]
      query_node[:condition] = resolve_condition(
        condition:  query_node[:condition],
        query_node: query_node,
      )
    end

    # If this is a relationship and there is no condition, there is no data to load
    resolve = !query_node[:parent_relationship] || !!query_node[:condition]

    [:ok, query_node: query_node, resolve: resolve]
  end

  def self.resolve_condition(condition:, query_node:)
    if condition.respond_to?(:call)
      condition = condition.call(query_node: query_node)
    end

    if condition&.dig(:op)
      if condition[:op].in?([:or, :and])
        condition[:values] = condition[:values].map do |value|
          resolve_condition(condition: value, query_node: query_node)
        end
      end
    end

    condition
  end

  before Ct::Hash[query_node: Ct::QueryNode]
  after  Ct::Result[query_node: Ct::QueryNode]
  def self.resolve_data(query_node:, resolve:)
    if !resolve
      query_node[:records] = []
      return [:ok, query_node: query_node]
    end

    result      = query_node[:resolvers][:data_resolver].call(query_node: query_node)
    status, ctx = result

    if status == :error
      return result
    end

    query_node[:records] = ctx[:data].map do |raw_data|
      {
        query_node:    query_node,
        raw_data:      raw_data,
        meta:          {},
        relationships: {},
      }
    end

    [:ok, query_node: query_node]
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

  def self.resolve_relationships_records(query_node:, resolve:)
    return [:ok, query_node: query_node] if !resolve

    query_node[:relationships].each do |relationship_name, relationship|
      child_query_node = relationship[:child_query_node]
      child_records    = child_query_node[:records]

      query_node[:records].each do |parent_record|
        selector = relationship[:resolvers][:records_selector].call(parent_record: parent_record)
        parent_record[:relationships][relationship_name] = child_records.select(&selector)
      end
    end

    [:ok, query_node: query_node]
  end

end
