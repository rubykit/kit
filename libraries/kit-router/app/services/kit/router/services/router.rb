# High level routing logic.
module Kit::Router::Services::Router

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  # Register an endpoint.
  def self.register(uid:, aliases:, target:, types: { [:any, :any] => nil }, meta: nil, router_store: nil, after: nil)
    types        ||= { [:any, :any] => nil }
    router_store ||= self.router_store

    # NOTE: temporary
    return [:ok] if ENV['KIT_ROUTER'] == 'false'

    Kit::Router::Log.log(msg: "registering `#{ uid }` (aliases: #{ aliases })", flags: [:debug, :routes, :endpoint])

    # NOTES: does this make it too complex a function signature?
    meta ||= {}
    if types.is_a?(Hash)
      meta[:types] ||= types
      types = types.keys
    end

    # Delayed declaration of the route.
    if after && !router_store[:endpoints][uid]

      Kit::Router::Log.log(msg: "registering delayed for `#{ uid }` (waiting for: #{ after })", flags: [:debug, :routes, :endpoint])

      save_afters(uid: uid, target: target, types: types, meta: meta, aliases: aliases, after: after, router_store: router_store)
    else
      Kit::Router::Services::Store::Endpoint.add_endpoint(uid: uid, target: target, types: types, meta: meta, router_store: router_store)

      handle_aliases(target_id: uid, aliases: aliases, router_store: router_store)
      handle_afters(uid: uid, router_store: router_store)
    end

    [:ok]
  end

  # Because of engine initializers loading order, we need to delay the declaration of certain routes.
  def self.save_afters(uid:, target:, types:, meta:, aliases:, after:, router_store: nil)
    router_store ||= self.router_store
    after          = after.to_sym

    list = router_store[:afters][after] ||= []

    list << {
      uid:     uid,
      target:  target,
      types:   types,
      meta:    meta,
      aliases: aliases,
    }

    [:ok]
  end

  # Once a route is registered, check if there were some delayed declartions for that uid.
  # If so, register them now.
  def self.handle_afters(uid:, router_store: nil)
    router_store ||= self.router_store
    uid            = uid.to_sym

    list = router_store[:afters][uid] || []
    if list.size > 0
      list.each do |el|
        Kit::Router::Services::Store::Endpoint.add_endpoint(uid: el[:uid], target: el[:target], types: el[:types], meta: el[:meta], router_store: router_store)

        handle_aliases(target_id: el[:uid], aliases: el[:aliases], router_store: router_store)
      end
    end

    router_store[:afters].delete(uid)

    #binding.pry

    [:ok, router_store: router_store]
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

  # Last call to mount routes depending on `after` that don't exist.
  def self.finalize_endpoints(router_store: nil)
    router_store ||= self.router_store

    router_store[:afters].each do |uid, _|
      handle_afters(uid: uid, router_store: router_store)
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

      if record_protocol == mounter_protocol && (record_lib == mounter_lib || record_lib == :any)
        return true
      end

      if record_protocol == :any
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

  def self.cast(id:, request: nil, params: {}, router_store: nil)
    call(id: id, request: request, params: params, router_store: router_store)

    [:ok]
  end

  def self.router_store
    Kit::Router::Services::Store.router_store
  end

end
