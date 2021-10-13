# Routes setup for Rails.
module Kit::Router::Adapters::HttpRails::Routes

  MOUNT_TYPE = [:http, :rails]

  HTTP_VERBS = [:connect, :delete, :get, :options, :patch, :post, :put, :trace]

  def self.mount_http_targets(rails_router_context:, list:, request_config: nil, namespace: nil)
    list.each do |attrs|
      # NOTE: this seems like a bad API
      attrs[:namespace]      = namespace      if !attrs[:namespace]
      attrs[:request_config] = request_config if !attrs[:request_config]

      mount_http_target(rails_router_context: rails_router_context, **attrs)
    end

    [:ok]
  end

  def self.mount_http_target(route_id:, path:, verb:, rails_router_context:, rails_endpoint_wrapper:, request_config: nil, namespace: nil)
    return [:ok] if ENV['KIT_ROUTER'] == 'false'

    Kit::Organizer.call(
      list: [
        self.method(:load_record),
        self.method(:ensure_kit_router_target!),
        self.method(:ensure_valid_mountpoint!),
        self.method(:validate_rails_target),
        self.method(:mount_in_rails),
        self.method(:add_mountpoint_to_record),
      ],
      ctx:  {
        route_id:             route_id,
        path:                 path,
        verb:                 verb,
        namespace:            namespace,
        rails_target:         rails_endpoint_wrapper,
        rails_router_context: rails_router_context,
        request_config:       request_config,
      },
    )
  end

  def self.mount_rails_targets(rails_router_context:, list:)
    list.each do |attrs|
      mount_rails_target(rails_router_context: rails_router_context, **attrs)
    end

    [:ok]
  end

  def self.mount_rails_target(route_id:, path:, verb:, rails_router_context:, namespace: nil)
    Kit::Organizer.call(
      list: [
        self.method(:load_record),
        self.method(:extract_rails_target_from_record),
        self.method(:ensure_valid_mountpoint!),
        self.method(:validate_rails_target),
        self.method(:mount_in_rails),
        self.method(:add_mountpoint_to_record),
      ],
      ctx:  {
        route_id:             route_id,
        path:                 path,
        verb:                 verb,
        namespace:            namespace,
        rails_router_context: rails_router_context,
      },
    )
  end

  # --------------------------------------------------------------------------

  def self.load_record(route_id:)
    alias_record    = Kit::Router::Services::Store::Alias.get_alias(id: route_id)
    endpoint_record = Kit::Router::Services::Store::Endpoint.get_endpoint!(id: route_id)[1][:endpoint_record]

    endpoint_types = endpoint_record[:types].keys
    if !Kit::Router::Services::Router.can_mount?(endpoint_types: endpoint_types, mounter_type: MOUNT_TYPE)
      raise "Kit::Router | Can't mount `#{ endpoint_record[:id] }` (through: `#{ route_id }`) | Endpoint mount type: `#{ endpoint_record[:types] }` | Current mount type: `#{ MOUNT_TYPE }`"
    end

    [:ok, endpoint_record: endpoint_record, alias_record: alias_record]
  end

  def self.ensure_valid_mountpoint!(route_id:, path:, verb:)
    if path.blank?
      raise "Kit::Router | empty path for `#{ route_id }`"
    end

    verb = verb.to_s.downcase.to_sym
    if !HTTP_VERBS.include?(verb)
      raise "Kit::Router | unsupported http verb for `#{ route_id }` (`#{ verb }`)"
    end

    [:ok, rails_mountpoint: { data: [verb, path], meta: {} }]
  end

  def self.ensure_kit_router_target!(endpoint_record:, route_id:)
    endpoint_id       = endpoint_record[:id]
    endpoint_callable = endpoint_record[:target]

    if endpoint_callable&.respond_to?(:call) != true
      raise "Kit::Router | invalid target for #{ endpoint_id }"
    end

    target = {
      route_id:          route_id,
      endpoint_id:       endpoint_id,
      endpoint_callable: endpoint_callable,
    }

    [:ok, kit_router_target: target]
  end

  def self.validate_rails_target(rails_target:)
    rails_controller, rails_action = rails_target

    if rails_controller.is_a?(String)
      rails_controller_name = rails_controller
    else
      # REF: https://github.com/rails/rails/blob/9a2e00e27b87632be3528b53efb8bba504688711/actionpack/lib/action_dispatch/http/request.rb#L85
      rails_controller_name = rails_controller.name.underscore.gsub(%r{_controller$}, '')
    end
    rails_action_name = rails_action.to_sym

    [:ok, rails_target: [rails_controller_name, rails_action_name]]
  end

  # Declare endpoint in Rails router with a Rails wrapper.
  # NOTE: please only call this directly if you understand what you are doing!
  def self.mount_in_rails(rails_router_context:, rails_target:, rails_mountpoint:, endpoint_record:, request_config: nil, kit_router_target: nil)
    http_verb, http_path = rails_mountpoint[:data]
    request_config     ||= {}
    route_defaults       = endpoint_record[:meta][:route_defaults] || {}

    #puts "DEBUG: mount in rails: #{ http_verb } #{ http_path }"
    rails_router_context.send(:match, http_path, {
      controller: rails_target[0],
      action:     rails_target[1],
      via:        [http_verb],
      defaults:   route_defaults.merge({
        kit_request_config: request_config,
        kit_router_target:  kit_router_target,
      }),
    },)

    [:ok]
  end

  def self.add_mountpoint_to_record(alias_record:, rails_mountpoint:, namespace:)
    #alias_record[:mountpoints][MOUNT_TYPE] ||= []
    #alias_record[:mountpoints][MOUNT_TYPE] << rails_mountpoint

    rails_mountpoint[:meta][:namespace] = namespace

    # TODO: add uniqueness check?
    alias_record[:cached_mountpoints][MOUNT_TYPE] = rails_mountpoint

    [:ok]
  end

  def self.extract_rails_target_from_record(endpoint_record:)
    rails_target = endpoint_record.dig(:meta, :types, MOUNT_TYPE, :target)

    if !rails_target
      raise "Kit::Router | invalid record target for #{ endpoint_record[:id] }"
    end

    [:ok, rails_target: rails_target]
  end

end
