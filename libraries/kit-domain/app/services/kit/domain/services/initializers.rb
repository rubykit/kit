module Kit::Domain::Services::Initializers

  def self.load_endpoints(dir:)
    # On initialization
    autoloader   = Rails.autoloaders.main
    default_path = File.expand_path('../../app/endpoints', dir)

    Dir["#{ default_path }/**/*.rb"].each do |file|
      autoloader.preload(file)
    end

    # When autoreloading in development mode.
    Rails.application.reloader.after_class_unload do
      default_path = File.expand_path('../../app/endpoints', dir)
      Dir["#{ default_path }/**/*.rb"].each do |file|
        load(file)
      end
    end
  end

end