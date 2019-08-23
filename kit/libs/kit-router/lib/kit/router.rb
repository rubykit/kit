require 'uri'

module Kit
  module Router
    class << self

      def call(id:, request: nil, params: {})
        record = get_record(id: id)

        if !request
          request = Kit::Domain::Services::Request::Request.new(params: OpenStruct.new(params))
        end

        # TODO: fix the need to "unpack", not even sure we should do this in the first place
        target = record[:target_method].call

        target.call(request: request)
      end

      def map_routes(list:, context:)
        list.each do |uid, attrs|
          record = get_record(id: uid)

          # https://github.com/rails/rails/blob/9a2e00e27b87632be3528b53efb8bba504688711/actionpack/lib/action_dispatch/http/request.rb#L85
          controller_name = record[:controller].name.underscore.gsub(/_controller$/, '')
          action          = record[:action]

          path  = attrs[:path]
          if path.blank?
            raise "Kit::Router | empty path `#{uid}`"
          end

          verb = attrs[:verb]

          record[:mounted_verb] = verb
          record[:mounted_path] = path

          #puts "Kit::Router - Mounting `#{path}`".colorize(:green)

          defaults = {}
          if record[:target_method]
            defaults[:kit_router_method] = record[:target_method].call()
          end

          context.send :match, path, { action: action, controller: controller_name, via: [verb], defaults: defaults }
        end
      end

      def register_rails_action(uid:, aliases:, controller:, action:)
        #puts "Kit::Router - Registering `#{uid}` (aliases: #{aliases})".colorize(:green)
        add_to_store(uid: uid, controller: controller, action: action, target_method: nil)
        add_aliases(uid: uid, aliases: aliases)

        true
      end

      def register(uid:, aliases:, target: nil, object: nil, method_name: nil)
        #puts "Kit::Router - Registering `#{uid}` (aliases: #{aliases})".colorize(:green)

        if target
          real_target = target
          target = -> { real_target }
        else
          if object || method_name
            target = ->() { object.method(method_name) }
          else
            raise "Invalid target"
          end
        end

        controller = Kit::Router::Controllers::RouterController
        action     = :route

        add_to_store(uid: uid, controller: controller, action: action, target_method: target)
        add_aliases(uid: uid, aliases: aliases)

        true
      end

      def path(id:, params: {})
        record = get_record(id: id)
        path   = record[:mounted_path]

        if path.blank?
          raise "Kit::Router | not mounted `#{id}`"
        end

        uri = URI(path)

        new_path = uri.path

        params = params.map do |k, v|
          marker = ":#{k}"
          if path.include?(marker)
            new_path.gsub!(marker, v.to_s)
            nil
          else
            [k, v]
          end
        end.compact.to_h

        uri.path = new_path
        uri.query = Rack::Utils
          .parse_nested_query(uri.query)
          .merge(params)
          .to_query

        uri.to_s.gsub(/\?$/, '')
      end

      def url(id:, params: {})
        host   = ENV['URI_HOST']
        scheme = ENV['URI_SCHEME']

        if scheme.blank?
          scheme = 'http'
        end

        # TODO: fix this
        if host.blank?
          port = 3000
          host = 'localhost'
        end

        current_path = path(id: id, params: params)

        uri          = URI(current_path)
        uri.host     = host
        uri.port     = port
        uri.scheme   = scheme

        uri.to_s
      end

      def verb(id:)
        record = get_record(id: id)
        verb   = record[:mounted_verb]

        if verb.blank?
          raise "Kit::Router | not mounted `#{id}`"
        end

        verb
      end

      def is_request_route?(request:, id:, params: {})
        request_url = request&.url
        return false if request_url.blank?

        id_path = path(id: id, params: params)

        URI(request_url).path == URI(id_path).path
      end

      protected

      def add_aliases(uid:, aliases:)
        @aliases ||= {}

        if !aliases.is_a?(Array)
          aliases = [aliases]
        end

        aliases.each do |alias_id|
          @aliases[alias_id.to_sym] = uid.to_sym
        end
      end

      def add_to_store(uid:, controller:, action:, target_method: nil)
        uid = uid.to_sym

        @store ||= {}

        # NOTE: because of live reloading it is easier to allow this
        if (el = @store[uid.to_sym])
          if el[:controller].name == controller.name && el[:action] == action
             return
          else
            raise "Kit::Router | already defined route `#{uid}`"
          end
        end

        @store[uid.to_sym] = {
          controller:    controller,
          action:        action,
          target_method: target_method,
          mounted:       false,
        }
      end

      def get_record(id:)
        id = id.to_sym

        if !(record = store[id])
          if (alias_id = aliases[id])
            record = store[alias_id]
          end
        end

        if !record
          raise "Kit::Router | unknown route `#{id}`"
        end

        record
      end

      def store
        @store || {}
      end

      def aliases
        @aliases || {}
      end

    end
  end
end

require "kit/router/railtie"
