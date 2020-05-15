module Kit::JsonApiSpec::Resources::Serie::Relationships::Photos

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  after Ct::Relationship
  def self.relationship
    {
      name:                       :photos,

      parent_resource:            -> { Kit::JsonApiSpec::Resources::Serie.resource },
      child_resource:             -> { Kit::JsonApiSpec::Resources::Photo.resource },

      type:                       :to_many,

      inclusion_level:            1,

      inherited_filter:           ->(query_node:) do
        values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
          .map { |el| el[:raw_data] }
          .map { |el| el[:id] }
        if values.size > 0
          Kit::Api::JsonApi::Types::Condition[op: :and, values: [
            Kit::Api::JsonApi::Types::Condition[op: :in, column: :imageable_id,   values: values, upper_relationship: true],
            Kit::Api::JsonApi::Types::Condition[op: :eq, column: :imageable_type, values: ['Kit::JsonApiSpec::Models::Write::Serie']],
          ],]
        else
          nil
        end
      end,

      select_relationship_record: ->(parent_record:) do
        ->(child_record) { parent_record[:raw_data].id == child_record[:raw_data].imageable_id && child_record[:raw_data].imageable_type == 'Kit::JsonApiSpec::Models::Write::Serie' }
      end,
    }
  end

end
