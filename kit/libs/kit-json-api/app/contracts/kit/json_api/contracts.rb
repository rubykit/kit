module Kit::JsonApi::Contracts
  include Kit::Contract::BuiltInContracts

  FieldName     = Symbol
  FieldNames    = Array.of(FieldName)

  ColumnName    = Symbol

  ConditionOp   = In[:eq, :gt, :gte, :le, :lte, :in, :contain, :start_with, :end_with]
  ConditionOps  = Array.of(ConditionOp)
  Condition     = Hash[op: In[:and, :or, ConditionOp], column: Optional[ColumnName], values: Any]
  FilterName    = Symbol

  SortOrderType = In[:asc, :desc]
  SortOrder     = Tupple[Symbol, SortOrderType]
  SortOrders    = Array.of(SortOrder)

  RelationshipName = Symbol

  Relationship = Hash[
    resource_resolver: Callable,
  ]

  ResourceName  = Symbol
  #Resource      = IsA[::Kit::JsonApi::Types::Resource]
  Resource = Hash[
    name:          ResourceName,
    fields:        FieldNames,
    relationships: Hash.of(RelationshipName => Relationship),
    sort_fields:   Hash.of(FieldName        => Hash[order: SortOrders]),
    filters:       Hash.of(FilterName       => ConditionOps),
    data_loader:   Callable,
  ]

  QueryNode = Hash[
    resource:    Resource,
    condition:   Optional[Or[Condition, Callable]],
    sorting:     Optional[SortOrders],
    data:        Optional[Array], # data: nil if not loaded, array otherwise
    limit:       Numeric,
    meta:        Optional[Hash],
    data_loader: Callable,
  ]
  #QueryNode.with(:parent        => Optional[QueryNode])
  #QueryNode.with(:relationships => Hash.of(RelationshipName => QueryNode))

  Query = Hash[
    #fields:     Hash.of(Resource => FieldNames), # For sparse fieldset ?
    entry_node: QueryNode,
  ]

  #Resource = ?

end