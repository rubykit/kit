module Kit::JsonApi::Contracts
  include Kit::Contract::BuiltInContracts

  ResourceName = Symbol
  Resource     = IsA[::Kit::JsonApi::Types::Resource]

  FieldName  = Symbol
  FieldNames = Array.of(Field)

  OrderType  = In[:asc, :desc]
  OrderTypes = Array.of(OrderType)

  ConditionType  = Symbol
  ConditionTypes = Array.of(ConditionType)

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
    available_sorters:       Hash.of(FieldName => OrderTypes),
    available_filters:       Hash.of(FieldName => ConditionTypes),
    available_relationships: Relationships,
    data_loader:             Callable,
  ]

  QueryLayer = Hash[
    resource:      Resource,
    relationships: Hash.of(RelationshipName => QueryLayer),
    where:         Conditions,
    order_by:      Orders,
    # data: nil if not loaded, array otherwise
    data:          Optional[Array],
    meta:          Hash,
  ]

  Query = Hash[
    fields: Hash.of(Resource => Fields),
    layer:  QueryLayer,
  ]

  #Resource = ?

end