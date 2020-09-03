namespace :router do

  namespace :mountpoints do

    task show: :environment do
      Kit::Router::Services::CliDisplay.show_mountpoints
    end

  end

  namespace :aliases do

    desc 'Display a list of known routing aliases'
    task show: :environment do
      Kit::Router::Services::CliDisplay.show_aliases
    end

  end

end
