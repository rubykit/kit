module Kit::JsonApi::Contracts
  include Kit::Contract::BuiltInContracts

  ResourceName  = Symbol
  Resource      = IsA[::Kit::JsonApi::Types::Resource]

  FieldName     = Symbol
  FieldNames    = Array.of(FieldName)

  ColumnName    = Symbol

  ConditionOp   = In[:eq, :gt, :gte, :le, :lte, :in, :contain, :start_with, :end_with]
  Condition     = Hash[op: ConditionOp, field: ColumnName, values: Array]
  Conditions    = Array.of(Condition)

  SortOrderType = In[:asc, :desc]
  SortOrder     = Tupple[Symbol, SortOrderType]
  SortOrders    = Array.of(SortOrder)

  RelationshipName = Symbol

  Relationship = Hash[
    name:     RelationshipName,
    resource: Resource,
    defaults: Hash,
  ]
  Relationships = Array.of(Relationship)

  Resource = Hash[
    name:                    ResourceName,
    available_fields:        FieldNames,
    available_sorters:       Hash.of(FieldName => Array.of(SortOrderType)),
    available_filters:       Hash.of(FieldName => Array.of(ConditionOp)),
    available_relationships: Relationships,
    data_loader:             Callable,
  ]

  QueryNode = Hash[
    #resource:           Resource,
    filters:            Conditions,
    sorting:            SortOrders,
    data:               Optional[Array], # data: nil if not loaded, array otherwise
    meta:               Optional[Hash],
  ]
  QueryNode.with(:parent        => Optional[QueryNode])
  QueryNode.with(:relationships => Hash.of(RelationshipName => QueryNode))

  Query = Hash[
    fields:     Hash.of(Resource => FieldNames),
    entry_node: QueryNode,
  ]

  #Resource = ?

end