module ActiveAdmin
  class Application

    def load!
      unless loaded?
        ActiveSupport::Notifications.publish BeforeLoadEvent, self # before_load hook
        files.each { |file| load file }                            # load files
        #namespace(default_namespace)                               # init AA resources
        ActiveSupport::Notifications.publish AfterLoadEvent, self  # after_load hook
        @@loaded = true
      end
    end

    def routes(rails_router, list = {})
      load!

      namespaces_tmp = namespaces

      if !list.empty?
        namespaces_tmp = namespaces_tmp
          .instance_variable_get(:@namespaces)
          .slice(*list)
          .values
      end

      Router.new(router: rails_router, namespaces: namespaces_tmp).apply
    end

  end
end