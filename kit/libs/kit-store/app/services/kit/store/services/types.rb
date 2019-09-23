require 'dry-types'

module Kit::Store::Services
  module Types
    include ::Dry.Types

    # NOTE: main issue: lack of tuple validation + unclear boundary on what is type / data



    # CONCLUSION: use Types ONLY FOR TYPE CHECKING, NOT DATA VALIDATION!
    # Data validation can even be done through classic organized flow.

    # Revisit if support for tupples id added.

    Callable = Interface(:call)

    Adapter = Symbol.enum(:all, :http, :async)
    #Adapter = Symbol.enum(:http, :async, :websocket, :email)

    MountSubTypesHttp  = Symbol.enum(:rails)
    MountSubTypesAsync = Symbol.enum(:sidekiq)
    MountSubTypeAll    = Symbol.enum(:all)
    MountSubTypes      = MountSubTypesHttp | MountSubTypesAsync | MountSubTypeAll

    MountType          = Array.of(Adapter | MountSubTypes)
    MountPointData     = Hash
    MountTypeHash      = Hash.map(MountType, MountTypeHash)

    HttpVerb        = Symbol.enum(*Kit::Store::Services::Adapters::Http::VERBS)
    MountPointHttp  = Hash.schema(
      verb:     HttpVerb,
      path:     String,
    )
    MountPointAsync = Hash.schema(
      id:       String,
    )
    MountPoint      = MountPointHttp | MountPointAsync


    EndpointRecord = Hash.schema(
      uid:             Symbol,
      target:          (Callable | Nil),
      #types:          Array.of(MountType),
      supported_types: Array.of(MountType),
      mountpoints:     Hash.map(MountType, Array.of(MountPointData)),
      meta:            Hash,
    )

    # NOTE: For now let's keep 1 alias = 1 mountpoint (and not 1 mountpoint per adapter type)
    AliasRecord = Hash.schema(
      alias_id:            Symbol,
      target_id:           Symbol,
      cached_endpoint:     EndpointRecord.optional,
      mountpoint:          MountPoint.optional,
      aliases:             Hash.map(Symbol, Any), # Can not self reference
    )

    StoreStore = Hash.schema(
      endpoints:   Hash.map(Symbol, EndpointRecord),
      aliases:     Hash.map(Symbol, AliasRecord),
      mountpoints: Hash.map(Symbol, MountPoint),
    )

  end
end