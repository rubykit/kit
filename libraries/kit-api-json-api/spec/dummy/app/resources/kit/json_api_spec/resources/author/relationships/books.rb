module Kit::JsonApiSpec::Resources::Author::Relationships::Books

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  after Ct::Relationship
  def self.relationship
    {
      name:                       :books,

      parent_resource:            -> { Kit::JsonApiSpec::Resources::Author.resource },
      child_resource:             -> { Kit::JsonApiSpec::Resources::Book.resource },

      type:                       :to_many,

      inclusion_level:            1,

      inherited_filter:           ->(query_node:) do
        values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
          .map { |el| el[:raw_data] }
          .map { |el| el[:id] }
        if values.size > 0
          Kit::Api::JsonApi::Types::Condition[op: :in, column: :kit_json_api_spec_author_id, values: values, upper_relationship: true]
        else
          nil
        end
      end,

      select_relationship_record: ->(parent_record:) do
        ->(child_record) { parent_record[:raw_data].id == child_record[:raw_data].kit_json_api_spec_author_id }
      end,

      self_link:                  ->(relationship:) { Kit::Api::JsonApi::Services::Links.rs_self_link(relationship: relationship)[1][:link] },
      related_link:               ->(relationship:) { Kit::Api::JsonApi::Services::Links.rs_related_link(relationship: relationship)[1][:link] },
    }
  end

end
