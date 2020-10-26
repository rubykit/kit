# Default router tasks that will be embedded in every domain.
#
# Tasks that require per domain configuration need to be manually added to each domain.
# They can be found in the `Kit::Router::Services::Tasks` namespace.
#
namespace :router do

  namespace :mountpoints do

    task display: :environment do
      Kit::Router::Services::Cli.display_mountpoints
    end

  end

  namespace :aliases do

    desc 'Display a list of known routing aliases'
    task display: :environment do
      Kit::Router::Services::Cli.display_aliases
    end

  end

end
