gem_dir = Gem::Specification.find_by_name('kit-domain').gem_dir
require "#{ gem_dir }/db/migrate/20210916066020_create_request_metadata.rb"
