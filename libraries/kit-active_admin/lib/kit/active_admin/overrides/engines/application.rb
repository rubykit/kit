class ActiveAdmin::Application

  # Prevent the loading of the default namsepace.
  #
  # ### References
  # - https://github.com/activeadmin/activeadmin/blob/v2.13.1/lib/active_admin/application.rb#L113
  def load!
    unless loaded?
      ActiveSupport::Notifications.instrument BeforeLoadEvent, { active_admin_application: self } # before_load hook
      files.each { |file| load file } # load files
      # NOTE: the change is the next commented line.
      # namespace(default_namespace) # init AA resources
      ActiveSupport::Notifications.instrument AfterLoadEvent, { active_admin_application: self } # after_load hook
      @@loaded = true
    end
  end

  # Allow to select what admin namespaces to mount.
  #
  # ### References
  # - https://github.com/activeadmin/activeadmin/blob/v2.13.1/lib/active_admin/application.rb#L141
  def routes(rails_router, list = {})
    load!

    namespaces_tmp = namespaces

    if !list.empty?
      namespaces_tmp = namespaces_tmp
        .instance_variable_get(:@namespaces)
        .slice(*list)
        .values
    end

    ::ActiveAdmin::Router.new(router: rails_router, namespaces: namespaces_tmp).apply
  end

  # Prevents AA from hijacking auto-loading behaviour.
  #
  # ### References
  # - https://github.com/activeadmin/activeadmin/blob/v2.13.1/lib/active_admin/application.rb#L177
  def remove_active_admin_load_paths_from_rails_autoload_and_eager_load
  end

end