module Kit::Router::Services
  module Store

    # DOC: one mountpoint per alias.

    def self.add_endpoint(uid:, target:, types:, meta: {}, router_store: nil)
      router_store ||= self.router_store

      uid = uid.to_sym

      # NOTE: because of live reloading it is easier to allow this
      if router_store[:endpoints][uid] && ENV['KIT_ROUTER_ALLOW_ROUTE_RELOADING'] != true
        raise "Kit::Router | already defined uid `#{uid}`"
      end

      if types.is_a?(Array)
        if !types[0].is_a?(Array)
          types = [types]
        end

        types = types.map { |k| [k, {}] }.to_h
      end

      endpoint_record = Kit::Router::Services::Types::EndpointRecord[
        uid:    uid,
        target: target,
        types:  types,
        meta:   meta,
      ]

      # Note this is only for access
      router_store[:endpoints][uid] = endpoint_record

      add_alias(
        target_id:    uid,
        alias_id:     uid,
        router_store: router_store,
      )

      [:ok]
    end

    def self.get_alias(id:, router_store: nil)
      router_store ||= self.router_store

      id = id.to_sym

      alias_record = router_store[:aliases][id]
      if !alias_record
        raise "Kit::Router | unknown route `#{id}`"
      end

      alias_record
    end

    def self.get_mountpoint(alias_record:, mountpoint_type:, router_store: nil)
      router_store ||= self.router_store

      mountpoint = alias_record[:mountpoint]

      if !mountpoint
        mountpoints = endpoint_record[:mountpoints][mountpoint_type]
        if mountpoints.size == 1
          mountpoint = mountpoints.first
        end
      end

      if !mountpoint
        raise "Kit::Router | could not find an endpoint for `#{alias_record[:id]}` type `#{mountpoint_type}`"
      end

      mountpoint
    end

    def self.get_endpoint(id:, router_store: nil)
      router_store ||= self.router_store

      id = id.to_sym

      alias_record = router_store[:aliases][id]
      if !alias_record
        raise "Kit::Router | unknown route `#{id}`"
      end

      endpoint_record = alias_record[:cached_endpoint]
      if !endpoint_record
        raise "Kit::Router | unknown endpoint_record for alias `#{id}`"
      end

      endpoint_record
    end

    def self.add_aliases(target_id:, aliases:, router_store: nil)
      router_store ||= self.router_store

      target_id = target_id.to_sym
      aliases   = (aliases.is_a?(Array) ? aliases : [aliases])
        .map { |el| el.to_sym }

      aliases.each do |alias_id|
        add_alias(
          target_id:    target_id,
          alias_id:     alias_id,
          router_store: router_store,
        )
      end
    end

    def self.add_alias(target_id:, alias_id:, router_store: nil)
      router_store ||= self.router_store

      target_alias_record = router_store[:aliases][target_id]
      alias_record        = router_store[:aliases][alias_id]
      cached_endpoint     = target_alias_record&.dig(:cached_endpoint)

      if target_id == alias_id
        cached_endpoint = router_store[:endpoints][target_id]
      end

      if !target_alias_record && !cached_endpoint
        raise "Kit::Router | unknown target for alias `#{target_id}`"
      end

      if !alias_record
        router_store[:aliases][alias_id] = Kit::Router::Services::Types::AliasRecord[
          alias_id:        alias_id,
          target_id:       target_id,
          cached_endpoint: cached_endpoint,
          mountpoint:      nil,
          aliases:         {},
        ]
      else
        previous_target = router_store[:aliases][alias_record[:target_id]]
        previous_target[:aliases].delete(id)

        # NOTE: We can not use target_id[:cached_endpoint] because there might
        #  be a circular dependency, it needs to be recomputed.
        alias_record.merge!(
          target_id:       target_id,
          cached_endpoint: nil,
        )

        cached_endpoint = resolve_endpoint(alias_record: alias_record)[1][:endpoint_record]

        update_alias_chain(
          alias_record:    alias_record,
          cached_endpoint: cached_endpoint,
          router_store:    router_store,
        )
      end
    end

    def self.update_alias_chain(alias_record:, cached_endpoint:, router_store: nil)
      router_store ||= self.router_store

      alias_record[:cached_endpoint] = cached_endpoint
      alias_record[:aliases].each do |child_alias_id|
        child_alias_record = router_store[:aliases][child_alias_id]
        update_alias_chain(
          alias_record:    child_alias_record,
          cached_endpoint: cached_endpoint,
          router_store:    router_store,
        )
      end
    end

    def self.resolve_endpoint(alias_record:, router_store: nil)
      router_store ||= self.router_store

      endpoint_record = nil
      traversed_ids   = []

      loop do
        current_id = alias_record[:alias_id]
        if traversed_ids.include?(current_id)
          raise "Kit::Router | circular alias chain `#{current_id}`"
        end
        traversed_ids << current_id

        target_id = alias_record[:target_id]
        if (current_id == target_id)
          endpoint_record = alias_record[:cached_endpoint]
          break
        end

        alias_record = router_store[:aliases][target_id]
      end

      [:ok, endpoint_record: endpoint_record]
    end

    def self.router_store
      @router_store ||= create_store
    end

    def self.create_store
      Kit::Router::Services::Types::RouterStore[
        endpoints:   {},
        aliases:     {},
        mountpoints: {
          [:http, :rails] => [],
        },
      ]
    end

  end
end