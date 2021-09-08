# Contracts for the project
module Kit::Router::Contracts

  include Kit::Organizer::Contracts

  EndpointUid     = Or[Symbol, String].named('EndpointUid')
  AliasId         = Or[Symbol, String].named('AliasId')
  EndpointId      = Or[EndpointUid, AliasId].named('EndpointUid')

  Protocol        = In[:any, :http, :async].named('Protocol')
  MountSubTypes   = In[:any, :rails, :sidekiq].named('MountSubTypes')
  MountType       = Tupple[Protocol, MountSubTypes].named('MountType')
  MountTypes      = Array.of(MountType).named('MountTypes')

  MountPointData  = Hash.named('MountPointData')
  MountTypeHash   = Hash.of(MountType => Array.of(MountPointData)).named('MountTypeHash')

  HttpVerb        = In[*Kit::Router::Adapters::HttpRails::VERBS].named('HttpVerb')
  MountPointHttp  = Hash[verb: HttpVerb, path: String].named('MountPointHttp')
  #MountPointAsync = Hash[id: String]
  MountPoint      = Or[
    MountPointHttp,
    #MountPointAsync,
  ]

  # TODO: Links should be Stores ?

  EndpointRecord = Hash[
    id:             EndpointUid.named('EndpointRecord: uid'),
    target:         Optional[Callable].named('EndpointRecord: target'),

    types:          Hash.of(MountType => Hash).named('EndpointRecord: types'), # NO CLUE WHY
    #supported_types: Array.of(MountType),
    #mountpoints:     MountTypeHash,
    meta:           Hash.named('EndpointRecord: meta'),

    cached_aliases: Array.of(AliasId),

  ].named('EndpointRecord')

  # NOTE: For now let's keep 1 alias = 1 mountpoint (and not 1 mountpoint per adapter type)

  AliasRecord = Hash[
    id:                 AliasId.named('AliasRecord: alias_id'),
    target_id:          Optional[Or[AliasId, EndpointId]],
    cached_aliases:     Array.of(AliasId),
    cached_mountpoints: Array.of(MountPoint),
  ].named('AliasRecord')

  RouterStore = Hash[
    endpoints:   Hash.of(EndpointUid => EndpointRecord),
    aliases:     Hash.of(AliasId     => AliasRecord),
    mountpoints: Array,
  ].named('RouterStore')

end
