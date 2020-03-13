module Kit::JsonApi::Contracts
  #include Kit::Contract::BuiltInContracts
  include Kit::Organizer::Contracts

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

  QueryNodeType = IsA[::Kit::JsonApi::Types::QueryNode]

  # @note QueryNodeType is used on purpose in order to avoid creating circular checks in contracts
  QueryNode     = And[
    QueryNodeType,
    Hash[
      resource:                 Resource,
      condition:                Optional[Or[Condition, Callable]],
      sorting:                  Optional[SortOrders],
      data:                     Optional[Array], # data: nil if not loaded, array otherwise
      limit:                    Numeric,
      meta:                     Optional[Hash],
      data_loader:              Callable,
      parent_query_node:        Optional[QueryNodeType],
      parent_relationship_name: Optional[Symbol],
      relationship_query_nodes: Hash.of(RelationshipName => QueryNodeType),
    ]
  ]

  DocumentType = IsA[::Kit::JsonApi::Types::Document]

  Document = And[
    DocumentType,
    Hash[
      cache:    Hash,
      included: Hash,
      response: Hash[
        data:     Or[Array, Hash],
        included: Array,
      ],
    ],
  ]

  # TODO: make this correct
  ResourceObject = Any

  DataElement = Hash[
    raw_data: Any,
    resource_object: ResourceObject,
  ]

end