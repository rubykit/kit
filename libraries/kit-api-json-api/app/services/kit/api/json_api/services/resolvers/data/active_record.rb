# ActiveRecord data resolver.
module Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  # Return a generic condition generator for a nested relationship QueryNode
  # If field_name is a tupple, this is a polymorphic field.
  def self.generate_inherited_filters(relationship_type:, field_name:)
    if relationship_type == :to_many
      inherited_filter_to_many(field_name: field_name)
    else
      inherited_filter_to_one(field_name: field_name)
      # ?
    end
  end

  def self.inherited_filter_to_one(field_name:)
    if field_name.is_a?(Symbol) || field_name.is_a?(String)
      inherited_filter_to_one_classic(field_name: field_name)
    else
      inherited_filter_to_one_polymorphic(field_name)
    end
  end

  after Ct::Callable
  def self.inherited_filter_to_one_classic
    ->(query_node:) do
      values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
        .map { |el| el[:raw_data] }
        .map { |el| el[field_name] }
      if values.size > 0
        { op: :in, column: :id, values: values, upper_relationship: true }
      else
        nil
      end
    end
  end

  after Ct::Callable
  def self.inherited_filter_to_one_polymorphic(column_name_id:, column_name_type:, model_name:)
    ->(query_node:) do
      values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
        .map    { |el| el[:raw_data] }
        .select { |el| el[column_name_type] == model_name }
        .map    { |el| el[column_name_id] }
      if values.size > 0
        { op: :in, column: :id, values: values, upper_relationship: true }
      else
        nil
      end
    end
  end

  after Ct::Callable
  def self.inherited_filter_to_many(field_name:)
    ->(query_node:) do
      values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
        .map { |el| el[:raw_data] }
        .map { |el| el[:id] }
      if values.size > 0
        if field_name.is_a?(Symbol) || field_name.is_a?(String)
          Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.condition_to_many(column_name: field_name)
        else
          Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.condition_to_many_polymorphic(field_name)
        end
      else
        nil
      end
    end
  end

  after Ct::Condition
  def self.condition_to_many(column_name:)
    { op: :in, column_name: column, values: values, upper_relationship: true }
  end

  def self.condition_to_many_polymorphic(column_name_id:, column_name_type:, model_name:)
    { op: :and, values: [
      { op: :in, column: column_name_id,   values: values, upper_relationship: true },
      { op: :eq, column: column_name_type, values: [model_name] },
    ],}
  end

  # ----------------------------------------------------------------------------

  def self.generate_records_selector(relationship_type:, field_name:)
    if relationship_type == :to_many
      records_selector_to_many(field_name: field_name)
    else
      records_selector_to_one(field_name: field_name)
    end
  end

  # Note: we use read_attribute for JOINs where we added the data on the element.
  def self.records_selector_to_many(field_name:)
    ->(parent_record:) do
      ->(child_record) { parent_record[:raw_data].id == child_record[:raw_data].read_attribute(field_name) }
    end
  end

  # Note: we use read_attribute for JOINs where we added the data on the element.
  def self.records_selector_to_one(field_name:)
    ->(parent_record:) do
      ->(child_record) { parent_record[:raw_data].read_attribute(field_name) == child_record[:raw_data].id }
    end
  end

  # ----------------------------------------------------------------------------

  def self.data_resolver(query_node:, model:, assemble_sql_query: nil)
    _, ctx = Kit::Api::JsonApi::Services::Sql.sql_query(
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

  def self.generate_data_resolver(model:, assemble_sql_query: nil)
    data_resolver = ->(query_node:) do
      Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.data_resolver({
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
      _, ctx = Kit::Api::JsonApi::Services::Sql.sql_query(
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
