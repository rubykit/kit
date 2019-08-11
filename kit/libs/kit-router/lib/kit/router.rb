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

      def register(uid:, controller:, action:, engine: nil)
        #controller.ancestors.include?(ActionController::Metal)

        @store ||= {}
        if @store[uid.to_sym]
          @store[uid.to_sym].merge({ controller: controller, action: action })
        else
          @store[uid.to_sym] = { controller: controller, action: action, mounted: false }
        end

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

      def get_record(uid:)
        uid = uid.to_sym
        if !(record = store[uid])
          raise "Kit::Router | unknown route `#{uid}`"
        end

        record
      end


      def store
        @store || {}
      end

    end
  end
end
