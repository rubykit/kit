require 'uri'

module Kit
  module Router
    class << self

      def map_routes(list:, context:)
        list.each do |uid, attrs|
          record = get_record(uid: uid)

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

          context.send :match, path, { action: action, controller: controller_name, via: [verb] }
        end
      end

      def register(uid:, aliases:, controller:, action:)
        #controller.ancestors.include?(ActionController::Metal)

        add_to_store(uid: uid, controller: controller, action: action)
        add_aliases(uid: uid, aliases: aliases)

        true
      end

      def path(uid:, params:)
        record = get_record(uid: uid)
        path   = record[:mounted_path]

        if path.blank?
          raise "Kit::Router | not mounted `#{uid}`"
        end

        uri = URI(path)

        new_path = uri.path

        params = params.each do |k, v|
          marker = ":#{k}"
          if path.include?(marker)
            new_path.gsub!(marker, v)
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

        uri.to_s
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

      def add_to_store(uid:, controller:, action:)
        uid = uid.to_sym

        @store ||= {}

        if @store[uid.to_sym]
          raise "Kit::Router | already defined route `#{uid}`"
        end

        @store[uid.to_sym] = { controller: controller, action: action, mounted: false }
      end

      def get_record(uid:)
        uid = uid.to_sym

        if !(record = store[uid])
          if (alias_id = aliases[uid])
            record = store[alias_id]
          end
        end

        if !record
          raise "Kit::Router | unknown route `#{uid}`"
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
