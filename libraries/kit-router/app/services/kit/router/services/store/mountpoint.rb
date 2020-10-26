# Store mountpoints related methods
module Kit::Router::Services::Store::Mountpoint

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  # Find first mountpoint in an alias list.
  contract Ct::Hash[mountpoint_type: Ct::MountType]
  def self.find_mountpoint(id:, mountpoint_type:, router_store: nil)
    router_store ||= self.router_store

    mountpoint = nil
    record_id  = id.to_sym

    loop do
      break if !record_id

      record = router_store[:aliases][record_id] || router_store[:endpoints][record_id]
      break if !record

      mountpoint = record[:cached_mountpoints]&.dig(mountpoint_type)
      break if mountpoint

      record_id = record[:target_id]
    end

    if !mountpoint
      raise "Kit::Router | could not find a mountpoint for `#{ id }` with `#{ mountpoint_type }`"
    end

    [:ok, mountpoint_data: mountpoint]
  end

  def self.router_store
    Kit::Router::Services::Store.router_store
  end

end
