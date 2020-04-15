module Kit::JsonApiSpec::Resources::Photo::Relationships::Chapter

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  after Ct::Relationship
  def self.relationship
    {
      name:                       :author,

      parent_resource:            -> { Kit::JsonApiSpec::Resources::Photo.resource },
      child_resource:             -> { Kit::JsonApiSpec::Resources::Chapter.resource },

      type:                       :to_one,

      inclusion_level:            1,

      inherited_filter:           ->(query_node:) do
        values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
          .map    { |el| el[:raw_data] }
          .select { |el| el[:imageable_type] == 'Kit::JsonApiSpec::Models::Write::Chapter' }
          .map    { |el| el[:imageable_id] }
        if values.size > 0
          Kit::JsonApi::Types::Condition[op: :in, column: :id, values: values, upper_relationship: true]
        else
          nil
        end
      end,

      select_relationship_record: ->(parent_record:) do
        ->(child_record) { parent_record[:raw_data].imageable_id == child_record[:raw_data].id }
      end,
    }
  end

end
