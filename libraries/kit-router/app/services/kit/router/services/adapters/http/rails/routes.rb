# Routes setup for Rails.
module Kit::Router::Services::Adapters::Http::Rails::Routes

  MOUNT_TYPE = [:http, :rails]

  def self.mount_http_targets(rails_router_context:, list:, namespace: nil)
    list.each do |attrs|
      # NOTE: this seems like a bad API
      attrs[:namespace] = namespace if !attrs[:namespace]

      mount_http_target(rails_router_context: rails_router_context, **attrs)
    end

    [:ok]
  end

  def self.mount_http_target(id:, path:, verb:, rails_router_context:, rails_endpoint_wrapper:, namespace: nil)
    return [:ok] if ENV['KIT_ROUTER'] == 'false'

    Kit::Organizer.call({
      list: [
        self.method(:load_record),
        self.method(:ensure_kit_router_target!),
        self.method(:ensure_valid_mountpoint!),
        self.method(:validate_rails_target),
        self.method(:mount_in_rails),
        self.method(:add_mountpoint_to_record),
      ],
      ctx:  {
        id:                   id,
        path:                 path,
        verb:                 verb,
        namespace:            namespace,
        rails_target:         rails_endpoint_wrapper,
        rails_router_context: rails_router_context,
      },
    })
  end

  def self.mount_rails_targets(rails_router_context:, list:)
    list.each do |attrs|
      mount_rails_target(rails_router_context: rails_router_context, **attrs)
    end

    [:ok]
  end

  def self.mount_rails_target(id:, path:, verb:, rails_router_context:, namespace: nil)
    Kit::Organizer.call({
      list: [
        self.method(:load_record),
        self.method(:extract_rails_target_from_record),
        self.method(:ensure_valid_mountpoint!),
        self.method(:validate_rails_target),
        self.method(:mount_in_rails),
        self.method(:add_mountpoint_to_record),
      ],
      ctx:  {
        id:                   id,
        path:                 path,
        verb:                 verb,
        namespace:            namespace,
        rails_router_context: rails_router_context,
      },
    })
  end

  # --------------------------------------------------------------------------

  def self.load_record(id:)
    alias_record    = Kit::Router::Services::Store::Alias.get_alias(id: id)
    endpoint_record = Kit::Router::Services::Store::Endpoint.get_endpoint(id: id)

    endpoint_types = endpoint_record[:types].keys
    if !Kit::Router::Services::Router.can_mount?(endpoint_types: endpoint_types, mounter_type: MOUNT_TYPE)
      raise "Kit::Router | Can't mount `#{ endpoint_record[:uid] }` (through: `#{ id }`) | Endpoint mount type: `#{ endpoint_record[:types] }` | Current mount type: `#{ MOUNT_TYPE }`"
    end

    [:ok, endpoint_record: endpoint_record, alias_record: alias_record]
  end

  def self.ensure_valid_mountpoint!(id:, path:, verb:)
    if path.blank?
      raise "Kit::Router | empty path for `#{ id }`"
    end

    verb = verb.to_s.downcase.to_sym
    if !Kit::Router::Services::Adapters::Http::VERBS.include?(verb)
      raise "Kit::Router | unsupported http verb for `#{ id }` (`#{ verb }`)"
    end

    [:ok, rails_mountpoint: { data: [verb, path], meta: {} }]
  end

  def self.ensure_kit_router_target!(endpoint_record:)
    kit_router_target = endpoint_record[:target]
    if kit_router_target&.respond_to?(:call) != true
      raise "Kit::Router | invalid target for #{ endpoint_record[:uid] }"
    end

    [:ok, kit_router_target: kit_router_target]
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

  # NOTE: please only call this directly if you understand what you are doing!
  def self.mount_in_rails(rails_router_context:, rails_target:, rails_mountpoint:, kit_router_target: nil)
    # puts "Mount in rails: #{ rails_mountpoint }"
    http_verb, http_path = rails_mountpoint[:data]
    rails_router_context.send(:match, http_path, {
      controller: rails_target[0],
      action:     rails_target[1],
      via:        [http_verb],
      defaults:   {
        kit_router_target: kit_router_target,
      },
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
      raise "Kit::Router | invalid record target for #{ endpoint_record[:uid] }"
    end

    [:ok, rails_target: rails_target]
  end

end
