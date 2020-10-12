namespace :router do

  namespace :mountpoints do

    task display: :environment do
      Kit::Router::Services::CliDisplay.display_mountpoints
    end

  end

  namespace :aliases do

    desc 'Display a list of known routing aliases'
    task display: :environment do
      Kit::Router::Services::CliDisplay.display_aliases
    end

    desc 'Display a list of known routing aliases'
    task generate_alias_graph_assets: :environment do
      Kit::Router::Services::CliDisplay.generate_alias_graph_assets
    end

  end

end
