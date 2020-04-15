module Kit::JsonApiSpec::Resources::Book::Relationships::BookStores

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  after Ct::Relationship
  def self.relationship
    {
      name:                       :book_stores,

      parent_resource:            -> { Kit::JsonApiSpec::Resources::Book.resource },
      child_resource:             -> { Kit::JsonApiSpec::Resources::BookStore.resource },

      type:                       :to_many,

      inclusion_level:            1,

      inherited_filter:           ->(query_node:) do
        values = (query_node&.dig(:parent_query_node, :data) || [])
          .map { |el| el[:id] }
        if values.size > 0
          Kit::JsonApi::Types::Condition[op: :in, column: :kit_json_api_spec_book_id, values: values, upper_relationship: true]
        else
          nil
        end
      end,

      select_relationship_record: ->(parent_record:) do
        ->(child_record) { parent_record[:raw_data].id == child_record[:raw_data].kit_json_api_spec_book_id }
      end,
    }
  end

end
