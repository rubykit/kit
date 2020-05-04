# Contracts for the project
module Kit::JsonApi::Contracts

  #include Kit::Contract::BuiltInContracts
  include Kit::Organizer::Contracts

  FieldName     = Symbol
  FieldNames    = Array.of(FieldName)

  ColumnName    = Symbol

  ConditionOp   = In[:eq, :gt, :gte, :lt, :lte, :in, :contain, :start_with, :end_with]
  ConditionOps  = Array.of(ConditionOp)
  Condition     = Hash[op: In[:and, :or, ConditionOp], column: Optional[ColumnName], values: Any]
  FilterName    = Symbol

  SortOrderType = In[:asc, :desc]
  SortOrder     = Tupple[Symbol, SortOrderType]
  SortOrders    = Array.of(SortOrder)

  RelationshipName = Symbol

  Relationship = Hash[
    name:             Symbol,
    type:             In[:to_one, :to_many],
    inclusion_level:  Integer,

    parent_resource:  Callable,
    child_resource:   Callable,

    inherited_filter: Callable,

    #parent_query_node: Optional[QueryNode],
    #child_query_node:  Optional[QueryNode],
  ]

  Record = Hash[
    query_node:    Delayed[-> { QueryNode }],
    raw_data:      Any,
    relationships: Hash.of(RelationshipName => Array.of(Delayed[-> { Record }])),
  ]

  ResourceName = Symbol
  #Resource      = IsA[::Kit::JsonApi::Types::Resource]
  Resource     = Hash[
    name:          ResourceName,
    fields:        FieldNames,
    relationships: Hash.of(RelationshipName => Relationship),
    sort_fields:   Hash.of(FieldName        => Hash[order: SortOrders]),
    filters:       Hash.of(FilterName       => ConditionOps),
    data_loader:   Callable,
  ]
  Resources = Array.of(Resource)

  QueryNodeType = IsA[::Kit::JsonApi::Types::QueryNode]

  # @note QueryNodeType is used on purpose in order to avoid creating circular checks in contracts
  QueryNode     = And[
    QueryNodeType,
    Hash[
      resource:            Resource,
      condition:           Optional[Or[Condition, Callable]],
      sorting:             Optional[SortOrders],
      records:             Optional[Array],
      limit:               Numeric,
      meta:                Optional[Hash],
      data_loader:         Callable,
      relationships:       Hash.of(RelationshipName => Relationship),
      parent_relationship: Optional[Relationship],
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
    raw_data:        Any,
    resource_object: ResourceObject,
  ]

  PositiveInt = And[Integer, ->(page_size) { page_size > 0 }]

  Config = Hash[
    resources:         Array.of(Resources),
    default_page_size: PositiveInt,
    max_page_size:     PositiveInt,
  ]

  Request = Hash[
    #top_level_resource: Resource,
    top_level_resource: Any,
    singular:           Boolean,
    related_resources:  Optional[Hash.of(String => Boolean)],
    sparse_fieldsets:   Optional[Hash.of(ResourceName => FieldNames)],
    limits:             Optional[Hash],
    #sorting:          {},
    #filtering:        {},
    #pagination:       {},
  ]

end
