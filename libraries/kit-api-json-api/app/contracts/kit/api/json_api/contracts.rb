# Contracts for the project
module Kit::Api::JsonApi::Contracts

  #include Kit::Contract::BuiltInContracts
  include Kit::Organizer::Contracts

  SymbolOrString = Or[Symbol, String].named('SymbolOrString')

  FieldName     = SymbolOrString.named('FieldName')
  FieldNames    = Array.of(FieldName).named('FieldNames')

  ColumnName    = SymbolOrString.named('ColumnName')

  ConditionOp   = In[:eq, :gt, :gte, :lt, :lte, :in, :contain, :start_with, :end_with]
  ConditionOps  = Array.of(ConditionOp).named('ConditionOps')
  ExtendedConditionOp = In[:and, :or, ConditionOp].named('ExtendedConditionOp')
  Condition     = Hash[op: ExtendedConditionOp, column: Optional[ColumnName], values: Any].named('Condition')
  FilterName    = SymbolOrString.named('FilterName')

  SortOrderType  = In[:asc, :desc].named('SortOrderType')
  SortOrderField = SymbolOrString.named('SortOrderField')
  SortOrder      = Tupple[SortOrderField, SortOrderType].named('SortOrder')
  SortOrders     = Array.of(SortOrder).named('SortOrders')

  ResourceName   = SymbolOrString.named('ResourceName')

  RelationshipName = SymbolOrString.named('RelationshipName')

  Relationship = Hash[
    name:              Optional[RelationshipName],
    resource:          ResourceName,
    relationship_type: In[:to_one, :to_many],
    inclusion_level:   Optional[Integer],
    #inherited_filter: Callable,

    parent_query_node: Optional[Delayed[-> { QueryNode }]],
    child_query_node:  Optional[Delayed[-> { QueryNode }]],
  ].named('Relationship')

  Resolvers = Hash[
    data_resolver:    Callable.named('Resolvers:data_resolver'),
    inherited_filter: Optional[Callable.named('Resolvers:inherited_filter')],
    records_selector: Optional[Callable.named('Resolvers:records_selector')],
  ]

  RelationshipHash = Hash.of(RelationshipName => Relationship).named('RelationshipHash')

  Record = Hash[
    query_node:    Delayed[-> { QueryNode }],
    raw_data:      Any,
    relationships: Hash.of(RelationshipName => Array.of(Delayed[-> { Record }])).named('Record[:relationships]'),
  ].named('Record')

  Resource = Hash[
    name:          ResourceName,
    fields:        FieldNames,
    relationships: RelationshipHash,
    sort_fields:   Hash.of(FieldName  => Hash[order: SortOrders]).named('Resource[:sort_fields]'),
    filters:       Hash.of(FilterName => ConditionOps).named('Resource[:filters]'),
    data_resolver: Callable,
  ].named('Resource')
  Resources = Array.of(Resource).named('Resources')

  QueryNode = Hash[
    resource:            Resource,
    condition:           Or[Nil, Callable, Condition].named('QueryNode[:condition]'),
    sorting:             Optional[SortOrders],
    records:             Optional[Array],
    limit:               Numeric,
    meta:                Optional[Hash.named('QueryNode[:meta]')],

    #data_resolver:       Callable.named('QueryNode[:data_resolver]'),
    resolvers:           Resolvers,

    relationships:       RelationshipHash,

    parent_relationship: Optional[Relationship],
  ].named('QueryNode')

  Document = Hash[
    cache:    Hash.named('Document[:cache]'),
    included: Hash.named('Document[:included]'),
    response: Hash[
      data:     Or[Array, Hash],
      included: Array,
    ].named('Document[:response]'),
  ].named('Document')

  # TODO: make this correct
  ResourceObject = Any

  DataElement = Hash[
    raw_data:        Any,
    resource_object: ResourceObject,
  ].named('DataElement')

  PositiveInt = And[Integer, ->(page_size) { page_size > 0 }]

  Config = Hash[
    resources:         Resources,
    default_page_size: PositiveInt,
    max_page_size:     PositiveInt,
  ].named('Config')

  Request = Hash[
    #top_level_resource: Resource,
    top_level_resource: Any,
    singular:           Boolean,
    related_resources:  Optional[Hash.of(String => Boolean).named('Request[:related_resources]')],
    sparse_fieldsets:   Optional[Hash.of(ResourceName => FieldNames).named('Request[:sparse_fieldsets]')],
    limits:             Optional[Hash.named('Request[:limits]')],
    #sorting:          {},
    #filtering:        {},
    #pagination:       {},
  ].named('Request')

end
