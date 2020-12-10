# ActiveRecord data resolver.
module Kit::Api::Services::Resolvers::ActiveRecord

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::Contracts

  ClassicField     = Ct::Hash[id: Ct::SymbolOrString].without(:type).named('ClassicField')
  PolymorphicField = Ct::Hash[id: Ct::SymbolOrString, type: Ct::SymbolOrString, model_name: Ct::SymbolOrString].named('PolymorphicField')

  #before Ct::Hash[config: Ct::Config, relationship: Ct::Relationship, options: Ct::Hash[foreign_key_field: Ct::NotEq[nil]]]
  before Ct::Hash[relationship: Ct::Relationship]
  after  Ct::Result[resolvers: Ct::Resolvers]
  def self.generate_resolvers(config:, relationship:, options:)
    child_field      = options[:child_field]  || :id
    parent_field     = options[:parent_field] || :id
    inherited_filter = options[:inherited_filter]
    records_selector = options[:records_selector]
    data_resolver    = options[:data_resolver]

    if !child_field.is_a?(Hash)
      child_field = { id: child_field }
    end
    if !parent_field.is_a?(Hash)
      parent_field = { id: parent_field }
    end

    relationship_type = relationship[:relationship_type]

    if !inherited_filter
      inherited_filter = generate_inherited_filters(relationship_type: relationship_type, child_field: child_field, parent_field: parent_field)
    end
    if !records_selector
      records_selector = generate_records_selector(relationship_type: relationship_type, child_field: child_field, parent_field: parent_field)
    end
    if !data_resolver
      _, ctx = generate_data_resolver({
        model: config[:resources][relationship[:resource]][:extra][:model_read],
      })

      data_resolver = ctx[:data_resolver]
    end

    [:ok, resolvers: {
      data_resolver:    data_resolver,
      inherited_filter: inherited_filter,
      records_selector: records_selector,
    },]

=begin
    [:ok, resolvers: {
      inherited_filter: inherited_filter_to_many(child_field: child_field, parent_field: parent_field),
      records_selector: records_selector_to_many(child_field: child_field, parent_field: parent_field),
      data_resolver:    ctx[:data_resolver],
    },]
=end
  end

  # Return a generic condition Callable for a nested relationship QueryNode
  def self.generate_inherited_filters(relationship_type:, child_field:, parent_field:)
    if relationship_type == :to_many
      if child_field[:type]
        inherited_filter_to_many_polymorphic(child_field: child_field, parent_field: parent_field)
      else
        inherited_filter_classic(child_field: child_field, parent_field: parent_field)
      end
    else
      if parent_field[:type] # rubocop:disable Style/IfInsideElse
        inherited_filter_to_one_polymorphic(child_field: child_field, parent_field: parent_field)
      else
        inherited_filter_classic(child_field: child_field, parent_field: parent_field)
      end
    end
  end

  before Ct::Hash[child_field: ClassicField, parent_field: ClassicField]
  after  Ct::Callable
  def self.inherited_filter_classic(child_field:, parent_field:)
    ->(query_node:) do
      values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
        .map { |el| el[:raw_data] }
        .map { |el| el[parent_field[:id]] }

      return nil if values.size == 0

      { op: :in, column: child_field[:id], values: values, upper_relationship: true }
    end
  end

  before Ct::Hash[child_field: PolymorphicField, parent_field: ClassicField]
  after  Ct::Callable
  def self.inherited_filter_to_many_polymorphic(child_field:, parent_field:)
    ->(query_node:) do
      values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
        .map { |el| el[:raw_data] }
        .map { |el| el[parent_field[:id]] }

      return nil if values.size == 0

      {
        op:     :and,
        values: [
          { op: :in, column: child_field[:id],   values: values, upper_relationship: true },
          { op: :eq, column: child_field[:type], values: [child_field[:model_name]] },
        ],
      }
    end
  end

  before Ct::Hash[child_field: ClassicField, parent_field: PolymorphicField]
  after  Ct::Callable
  def self.inherited_filter_to_one_polymorphic(child_field:, parent_field:)
    ->(query_node:) do
      values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
        .map    { |el| el[:raw_data] }
        .select { |el| el[parent_field[:type]] == parent_field[:model_name] }
        .map    { |el| el[parent_field[:id]] }

      return nil if values.size == 0

      { op: :in, column: child_field[:id], values: values, upper_relationship: true }
    end
  end

=begin
  #after Ct::Callable
  def self.inherited_filter_to_many(child_field:, parent_field:)
    ->(query_node:) do
      values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
        .map { |el| el[:raw_data] }
        .map { |el| el[:id] }
      if values.size > 0
        if field_name.is_a?(Symbol) || field_name.is_a?(String)
          Kit::Api::Services::Resolvers::ActiveRecord.condition_to_many(column_name: field_name, values: values)
        else
          Kit::Api::Services::Resolvers::ActiveRecord.condition_to_many_polymorphic(**field_name, values: values)
        end
      else
        nil
      end
    end
  end

  after Ct::Condition
  def self.condition_to_many(column_name:, values:)
    { op: :in, column: column_name, values: values, upper_relationship: true }
  end

  def self.condition_to_many_polymorphic(column_name_id:, column_name_type:, model_name:, values:)
    { op: :and, values: [
      { op: :in, column: column_name_id,   values: values, upper_relationship: true },
      { op: :eq, column: column_name_type, values: [model_name] },
    ], }
  end
=end

  # ----------------------------------------------------------------------------

  # Note: we use read_attribute for JOINs where we added the data on the element.
  after Ct::Callable
  def self.generate_records_selector(relationship_type:, child_field:, parent_field:)
    ->(parent_record:) do
      ->(child_record) { parent_record[:raw_data].read_attribute(parent_field[:id]) == child_record[:raw_data].read_attribute(child_field[:id]) }
    end
  end

  # ----------------------------------------------------------------------------

  def self.data_resolver(query_node:, model:, assemble_sql_query: nil)
    _, ctx = Kit::Api::Services::Resolvers::Sql.sql_query(
      ar_model:           model,
      filtering:          query_node[:condition],
      sorting:            query_node[:sorting],
      limit:              query_node[:limit],
      assemble_sql_query: assemble_sql_query,
    )

    puts ctx[:sql_str] if ENV['KIT_API_DEBUG']

    data = model.find_by_sql(ctx[:sql_str])

    [:ok, data: data]
  end

  def self.generate_data_resolver(model:, assemble_sql_query: nil)
    data_resolver = ->(query_node:) do
      Kit::Api::Services::Resolvers::ActiveRecord.data_resolver({
        query_node:         query_node,
        model:              model,
        assemble_sql_query: assemble_sql_query,
      })
    end

    [:ok, data_resolver: data_resolver]
  end

=begin

  def self.generate_data_resolver(model:, assemble_sql_query: nil)
    data_resolver = ->(query_node:) do
      _, ctx = Kit::Api::Services::Resolvers::Sql.sql_query(
        ar_model:           model,
        filtering:          query_node[:condition],
        sorting:            query_node[:sorting],
        limit:              query_node[:limit],
        assemble_sql_query: assemble_sql_query,
      )

      puts ctx[:sql_str]
      data = model.find_by_sql(ctx[:sql_str])
      puts "LOAD DATA #{ model.name.upcase }: #{ data.size }"

      [:ok, data: data]
    end

    [:ok, data_resolver: data_resolver]
  end

  def self.add_data_resolver(target:, model:, method_name: :load_data)
    _, ctx = generate_data_resolver(model: model)

    target.define_singleton_method :load_data, &(ctx[:data_resolver])

    [:ok, method_name: method_name]
  end
=end

end
