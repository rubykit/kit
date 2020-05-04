module Kit::JsonApiSpec::Resources::Book::Relationships::FirstChapter

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  after Ct::Relationship
  def self.relationship
    {
      name:                       :first_chapter,

      parent_resource:            -> { Kit::JsonApiSpec::Resources::Book.resource },
      child_resource:             -> { Kit::JsonApiSpec::Resources::Chapter.resource },

      type:                       :to_one,

      inclusion_level:            1,

      inherited_filter:           ->(query_node:) do
        values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
          .map { |el| el[:raw_data] }
          .map { |el| el[:id] }
        if values.size > 0
          Kit::JsonApi::Types::Condition[op: :and, values: [
            Kit::JsonApi::Types::Condition[op: :in, column: :kit_json_api_spec_book_id, values: values, upper_relationship: true],
            Kit::JsonApi::Types::Condition[op: :eq, column: :index, values: 1],
          ],]
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
