# High level routing logic.
module Kit::Router::Services::Router

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  # Register an endpoint.
  def self.register(uid:, aliases:, target:, types: { [:any, :any] => nil }, meta: nil, router_store: nil)
    # NOTE: temporary
    return [:ok] if ENV['KIT_ROUTER'] == 'false'

    if ['KIT_ROUTER_DEBUG'] == 'true'
      puts "Kit::Router - Registering `#{ uid }` (aliases: #{ aliases })".colorize(:green)
    end

    # NOTES: does this make it too complex a function signature?
    meta ||= {}
    if types.is_a?(Hash)
      meta[:types] ||= types
      types = types.keys
    end

    Kit::Router::Services::Store::Endpoint.add_endpoint(uid: uid, target: target, types: types, meta: meta, router_store: router_store)

    handle_aliases(target_id: uid, aliases: aliases, router_store: router_store)

    [:ok]
  end

  # Add aliases.
  # This supports nested logic.
  def self.handle_aliases(target_id:, aliases:, router_store: nil)
    case aliases
    when Array
      aliases.each do |alias_id|
        Kit::Router::Services::Store::Alias.add_alias(target_id: target_id, alias_id: alias_id, router_store: router_store)
      end
    when Hash
      handle_aliases(target_id: target_id, aliases: aliases.keys)

      aliases.each do |alias_id, aliases_sublist|
        handle_aliases(target_id: alias_id, aliases: aliases_sublist)
      end
    else
      Kit::Router::Services::Store::Alias.add_alias(target_id: target_id, alias_id: aliases, router_store: router_store)
    end

    [:ok]
  end

  EMPTY_TARGET = -> {} # rubocop:disable Lint/EmptyBlock

  def self.register_without_target(uid:, aliases:, types:)
    register(
      uid:     uid,
      aliases: aliases,
      target:  EMPTY_TARGET,
      types:   types,
    )
  end

  # [:any, :any] against [:http, :rails]
  contract Ct::Hash[endpoint_types: Ct::MountTypes, mounter_type: Ct::MountType]
  def self.can_mount?(endpoint_types:, mounter_type:)
    mounter_protocol, mounter_lib = mounter_type

    endpoint_types.each do |record_type|
      record_protocol, record_lib = record_type

      if record_protocol == mounter_protocol && record_lib == mounter_lib # rubocop:disable Style/GuardClause
        return true
      elsif record_protocol == mounter_protocol && record_lib == :any
        return true
      elsif record_protocol == :any
        return true
      end
    end

    false
  end

  def self.call(id:, request: nil, params: {}, router_store: nil)
    record = Kit::Router::Services::Store::Endpoint.get_endpoint(id: id, router_store: router_store)

    if !request
      request = Kit::Router::Models::RouterRequest.new(params: OpenStruct.new(params))
    end

    target = record[:target]

    target.call(request: request)
  end

end
