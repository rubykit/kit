module Kit::Router::Services::Store::Mountpoint

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  # Default to first mountpoint if N
  contract Ct::Hash[alias_record: Ct::AliasRecord, mountpoint_type: Ct::MountType]
  def self.get_record_mountpoint(alias_record:, mountpoint_type:, router_store: nil)
    endpoint_record = alias_record[:cached_endpoint]
    mountpoint      = alias_record[:mountpoint]
    if !mountpoint
      mountpoints = endpoint_record[:mountpoints][mountpoint_type]
      if mountpoints.size == 1
        mountpoint = mountpoints.first
      end
    end

    if !mountpoint
      raise "Kit::Router | could not find an endpoint for `#{ alias_record[:id] }` type `#{ mountpoint_type }`"
    end

    mountpoint
  end

end
