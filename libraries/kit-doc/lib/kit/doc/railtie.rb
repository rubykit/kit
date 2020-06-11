require 'rails'

# Handles file loading && initializers.
class Kit::Doc::Railtie < ::Rails::Railtie

=begin
  rake_tasks do
    load File.expand_path('../../../tasks/documentation.rake', __dir__)
  end
=end

end
