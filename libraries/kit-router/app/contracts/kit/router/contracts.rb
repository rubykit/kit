# Contracts for the project
module Kit::Router::Contracts

  include Kit::Contract::BuiltInContracts

  EndpointUid     = Or[Symbol, String]
  AliasId         = Or[Symbol, String]
  EndpointId      = Or[EndpointUid, AliasId]

  Protocol        = In[:any, :http, :async]
  MountSubTypes   = In[:any, :rails, :sidekiq]
  MountType       = Tupple[Protocol, MountSubTypes]
  MountTypes      = Array.of(MountType)

  MountPointData  = Hash
  MountTypeHash   = Hash.of(MountType => MountPointData)

  HttpVerb        = In[*Kit::Router::Services::Adapters::Http::VERBS]
  MountPointHttp  = Hash[verb: HttpVerb, path: String]
  #MountPointAsync = Hash[id: String]
  MountPoint      = Or[
    MountPointHttp,
    #MountPointAsync,
  ]

=begin
  # TODO: Links should be Stores ?

  EndpointRecord = And[
    IsA[Kit::Router::Types::EndpointRecord],
    Hash[
      uid:             EndpointUid,
      target:          Optional[Callable],
      #types:          Array.of(MountType),
      supported_types: Array.of(MountType),
      mountpoints:     Hash.of(MountType => Array.of(MountPointData)),
      meta:            Hash,
    ],
  ]
=end
  EndpointRecord = IsA[Kit::Router::Types::EndpointRecord]

=begin
  # NOTE: For now let's keep 1 alias = 1 mountpoint (and not 1 mountpoint per adapter type)

  AliasRecord = And[
    IsA[Kit::Router::Types::AliasRecord],
    Hash[
      alias_id:        AliasId,
      target_id:       Symbol,
      cached_endpoint: Optional[EndpointRecord],
      mountpoint:      Optional[MountPoint],
      #aliases:         Hash.of(AliasId => AliasRecord),
    ],
  ]
=end
  AliasRecord = IsA[Kit::Router::Types::AliasRecord]

=begin
  RouterStore = And[
    IsA[Kit::Router::Types::RouterStore],
    Hash[
      endpoints:   Hash.of(EndpointUid => EndpointRecord),
      aliases:     Hash.of(AliasId     => AliasRecord),
      mountpoints: Hash.of(Symbol      => MountPoint),
    ],
  ]
=end
  RouterStore = IsA[Kit::Router::Types::RouterStore]

end
