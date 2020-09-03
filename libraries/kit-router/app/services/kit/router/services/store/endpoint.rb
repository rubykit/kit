# Store endpoints related methods
module Kit::Router::Services::Store::Endpoint

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  #contract Ct::Hash[uid: Ct::EndpointUid, target: Ct::Callable, types: Ct::Array.of(Ct::MountType)]
  def self.add_endpoint(uid:, target:, types:, meta: {}, router_store: nil)
    router_store ||= self.router_store
    uid            = uid.to_sym

    # NOTE: because of live reloading it is easier to allow this
    if router_store[:endpoints][uid] && ENV['KIT_ROUTER_ALLOW_ROUTE_RELOADING'] != true
      raise "Kit::Router | already defined uid `#{ uid }`"
    end

    endpoint_record = {
      id:             uid,
      target:         target,
      types:          types.map { |k| [k, {}] }.to_h,
      meta:           meta,

      cached_aliases: [],
    }

    router_store[:endpoints][uid] = endpoint_record

    [:ok]
  end

  # Attempt to find an endpoint from an id (either alias or endpoint directly).
  contract Ct::Hash[id: Ct::EndpointId]
  def self.get_endpoint(id:, router_store: nil)
    router_store ||= self.router_store
    id             = id.to_sym

    target_id       = id
    endpoint_record = nil
    loop do
      endpoint_record = router_store[:endpoints][target_id]
      break if endpoint_record || !target_id

      target_id = router_store[:aliases][target_id]&.dig(:target_id)
    end

    if !endpoint_record
      raise "Kit::Router | unknown endpoint_record for alias `#{ id }`"
    end

    endpoint_record
  end

  # Given an `alias_record`, find the `endpoint` it should resolve to.
  # This need to be re-run when the aliasing chain evolves.
  contract Ct::Hash[alias_record: Ct::AliasRecord]
  def self.resolve_endpoint(alias_record:, router_store: nil)
    router_store ||= self.router_store

    endpoint_record = nil
    traversed_ids   = []

    loop do
      current_id = alias_record[:alias_id]
      if traversed_ids.include?(current_id)
        raise "Kit::Router | error: circular alias chain `#{ current_id }`"
      end

      traversed_ids << current_id

      target_id = alias_record[:target_id]
      if current_id == target_id
        endpoint_record = alias_record[:cached_endpoint]
        break
      end

      alias_record = router_store[:aliases][target_id] # || router_store[:endpoints][target_id]
    end

    [:ok, endpoint_record: endpoint_record]
  end

  def self.router_store
    Kit::Router::Services::Store.router_store
  end

end
