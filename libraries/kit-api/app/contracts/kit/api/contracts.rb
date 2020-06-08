# Contracts for the project
module Kit::Api::Contracts

  include Kit::Organizer::Contracts

  SymbolOrString      = Or[Symbol, String].named('SymbolOrString')
  PositiveInt         = And[Integer, ->(int) { int > 0 }]

  FieldName           = SymbolOrString.named('FieldName')
  FieldNames          = Array.of(FieldName).named('FieldNames')

  ColumnName          = SymbolOrString.named('ColumnName')

  ConditionOp         = In[:eq, :gt, :gte, :lt, :lte, :in, :contain, :start_with, :end_with]
  ConditionOps        = Array.of(ConditionOp).named('ConditionOps')
  ExtendedConditionOp = In[:and, :or, ConditionOp].named('ExtendedConditionOp')
  Condition           = Hash[op: ExtendedConditionOp, column: Optional[ColumnName], values: Any].named('Condition')
  FilterName          = SymbolOrString.named('FilterName')

  SortOrderType       = In[:asc, :desc].named('SortOrderType')
  SortOrderField      = SymbolOrString.named('SortOrderField')
  SortOrder           = Tupple[SortOrderField, SortOrderType].named('SortOrder')
  SortOrders          = Array.of(SortOrder).named('SortOrders')

  # Config ---------------------------------------------------------------------

  # The config for an API.
  Config = Hash[
    # Available Resources.
    resources:         Delayed[-> { ResourcesHash }],

    # Page size default.
    default_page_size: PositiveInt,
    # Max page size. The API will never return more record than this value.
    max_page_size:     PositiveInt,
  ].named('Config')

  # Resources ------------------------------------------------------------------

  ResourceName     = SymbolOrString.named('ResourceName')

  Resource         = Hash[
    name:          ResourceName,
    fields:        FieldNames,
    relationships: Delayed[-> { RelationshipsHash }],
    sort_fields:   Hash.of(FieldName  => Hash[order: SortOrders]).named('Resource[:sort_fields]'),
    filters:       Hash.of(FilterName => ConditionOps).named('Resource[:filters]'),
    data_resolver: Callable,
  ].named('Resource')

  Resources        = Array.of(Resource).named('Resources')
  ResourcesHash    = Hash.of(ResourceName => Resource).named('ResourcesHash')

  # Relationships --------------------------------------------------------------

  RelationshipName = SymbolOrString.named('RelationshipName')

  Relationship     = Hash[
    name:              Optional[RelationshipName],
    resource:          ResourceName,
    relationship_type: In[:to_one, :to_many],
    inclusion_level:   Optional[Integer],
    #inherited_filter: Callable,

    parent_query_node: Optional[Delayed[-> { QueryNode }]],
    child_query_node:  Optional[Delayed[-> { QueryNode }]],
  ].named('Relationship')

  RelationshipsHash = Hash.of(RelationshipName => Relationship).named('RelationshipsHash')

  # Resolvers ------------------------------------------------------------------

  Resolvers = Hash[
    data_resolver:    Callable.named('Resolvers:data_resolver'),
    inherited_filter: Optional[Callable.named('Resolvers:inherited_filter')],
    records_selector: Optional[Callable.named('Resolvers:records_selector')],
  ]

  # Request --------------------------------------------------------------------

  Request = Hash[
    top_level_resource: Delayed[-> { Resource }],
    singular:           Boolean,
    related_resources:  Optional[Hash.of(String => Delayed[-> { Resource }]).named('Request[:related_resources]')],
    sparse_fieldsets:   Optional[Hash.of(ResourceName => FieldNames).named('Request[:sparse_fieldsets]')],
    limits:             Optional[Hash.named('Request[:limits]')],
    #sorting:          {},
    #filtering:        {},
    #pagination:       {},
  ].named('Request')

  # Record ---------------------------------------------------------------------

  Record = Hash[
    query_node:      Delayed[-> { QueryNode }],
    raw_data:        Any,
    relationships:   Hash.of(RelationshipName => Delayed[-> { Records }]).named('Record[:relationships]'),
    resource_object: Or[Nil, Hash],
  ].named('Record')

  Records = Array.of(Record)

  # QueryNode ------------------------------------------------------------------

  QueryNode = Hash[
    resource:            Delayed[-> { Resource }],
    condition:           Or[Nil, Callable, Condition].named('QueryNode[:condition]'),
    sorting:             Optional[SortOrders],
    records:             Optional[Array],
    limit:               Numeric,
    meta:                Optional[Hash.named('QueryNode[:meta]')],
    resolvers:           Delayed[-> { Resolvers }],
    relationships:       Delayed[-> { RelationshipsHash }],
    parent_relationship: Optional[Delayed[-> { Relationship }]],
  ].named('QueryNode')

end
