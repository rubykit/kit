module Kit::JsonApiSpec::Resources::Chapter::Relationships::Book

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  after Ct::Relationship
  def self.relationship
    {
      name:                       :book,

      parent_resource:            -> { Kit::JsonApiSpec::Resources::Chapter.resource },
      child_resource:             -> { Kit::JsonApiSpec::Resources::Book.resource },

      type:                       :to_one,

      inclusion_level:            1,

      inherited_filter:           ->(query_node:) do
        values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
          .map { |el| el[:raw_data] }
          .map { |el| el[:kit_json_api_spec_book_id] }
        if values.size > 0
          Kit::Api::JsonApi::Types::Condition[op: :in, column: :id, values: values, upper_relationship: true]
        else
          nil
        end
      end,

      select_relationship_record: ->(parent_record:) do
        ->(child_record) { parent_record[:raw_data].kit_json_api_spec_book_id == child_record[:raw_data].id }
      end,
    }
  end

end
