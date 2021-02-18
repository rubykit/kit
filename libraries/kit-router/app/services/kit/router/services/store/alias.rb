# Store aliases related methods
module Kit::Router::Services::Store::Alias

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[id: Ct::AliasId]
  def self.get_alias(id:, router_store: nil)
    router_store ||= self.router_store
    id             = id.to_sym

    alias_record = router_store[:aliases][id]
    if !alias_record
      raise "Kit::Router | unknown route `#{ id }`"
    end

    alias_record
  end

  SET_ROUTER_STORE = ->(router_store:) do
    [:ok, router_store: router_store || self.router_store]
  end

  VALID_TARGET_ID = ->(target_id:, router_store:) do
    target_record = router_store[:endpoints][target_id] || router_store[:aliases][target_id]
    if target_record
      [:ok]
    else
      [:error, "Kit::Router | unknown target `#{ target_id }`"]
    end
  end

  before Ct::Hash[target_id: Ct::EndpointId, alias_id: Ct::AliasId]
  #after Ct::Result[alias_record: Ct::AliasRecord]
  def self.add_alias(target_id:, alias_id:, router_store: nil)
    router_store ||= self.router_store
    target_id      = target_id.to_sym
    alias_id       = alias_id.to_sym

    target_record = router_store[:endpoints][target_id] || router_store[:aliases][target_id]
    if !target_record
      raise "Kit::Router | unknown target `#{ target_id }`"
    end

    if router_store[:endpoints][alias_id]
      raise "Kit::Router | alias is an endpoint and can not be changed `#{ alias_id }`"
    end

    alias_record = router_store[:aliases][alias_id]
    if alias_record
      if circular_reference?(target_id: target_id, alias_id: alias_id, router_store: router_store)[0] == :error
        raise "Kit::Router | aliasing `#{ alias_id }` to `#{ target_id }` would create a circular reference"
      end

      # Update previous target alias cache
      previous_target_id = alias_record[:target_id]
      if previous_target_id
        previous_target = router_store[:endpoints][previous_target_id] || router_store[:aliases][previous_target_id]
        previous_target[:cached_aliases].delete(alias_id)
      end

      alias_record.merge!(
        target_id: target_id,
      )
    else
      alias_record = {
        alias_id:           alias_id,
        target_id:          target_id,
        cached_aliases:     [],
        cached_mountpoints: {},
      }

      router_store[:aliases][alias_id] = alias_record
    end

    target_record[:cached_aliases] << alias_id

    [:ok, alias_record: alias_record]
  end

  # Assess if alias can reference target without creating a circular reference.
  def self.circular_reference?(target_id:, alias_id:, router_store: nil)
    router_store  ||= self.router_store
    traversed_ids   = [alias_id]
    current_id      = target_id

    loop do
      return [:ok] if router_store[:endpoints][current_id]

      current_id = router_store[:aliases][current_id]&.dig(:target_id)
      return [:ok] if !current_id

      if traversed_ids.include?(current_id)
        return [:error]
      end

      traversed_ids << current_id
    end
  end

  def self.router_store
    Kit::Router::Services::Store.router_store
  end

end
