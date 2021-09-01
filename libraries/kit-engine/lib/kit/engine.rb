require 'pry'

module Kit # rubocop:disable Style/Documentation
end

# Shared logic to create Engines.
module Kit::Engine

  def self.config_engine(namespace:, context:, file:)
    context.isolate_namespace namespace

    # NOTE: Not sure why the number of .. must be different between the 2 !
    context.config.assets.paths     << File.expand_path('../../../../app/components', file)
    context.config.eager_load_paths << File.expand_path('../../../app/controllers',   file)

    engine_public_path = File.expand_path('../../../../public', file)
    if File.directory?(engine_public_path)
      context.initializer 'static assets' do |app|
        app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, engine_public_path)
      end
    end

=begin
    context.config.paths.add 'app/components', eager_load: true

    initializer_name = "#{ namespace.name.underscore.gsub('/', '_') }_engine"
    context.initializer initializer_name do
      ::ActiveAdmin.application.load_paths += Dir[File.expand_path('../../../app/admin', file)]
    end
=end
  end

end
