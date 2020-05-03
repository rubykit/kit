require 'yard'
require 'kit-doc-yard'
require 'rubygems'
require 'git'

require_relative '../version'

FILES_MODULES = {
  'kit/libs/kit-json-api'   => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
  'kit/libs/kit-organizer'  => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
  'kit/libs/kit-pagination' => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
}

FILES_EXTRA = {
  'docs/guides' => {
    include: %w[
      **/*.md
    ],
  },
}

def files_modules
  FILES_MODULES
    .map do |lib_path, data|
      (data[:include] || []).map { |path| "#{ lib_path }/#{ path }" }
    end
    .flatten
end

def files_extras
  FILES_EXTRA
    .map do |lib_path, data|
      (data[:include] || []).map { |path| Dir["#{ lib_path }/#{ path }"] }
    end
    .flatten
end

def groups_for_extras
  {
    'Introduction'  => [%r{guides/introduction/.?}],
    'Guides'        => [%r{guides/[^/]+.md}],
    'Architecture'  => [%r{guides/architecture/.?}],
    'Various'       => [%r{guides/various/.?}],
  }
end

def groups_for_modules
  {
    ''           => [
      %r{^Kit$}
    ],
    'Libs'       => [
      %r{^Kit::Organizer$},
      %r{^Kit::JsonApi$},
      %r{^Kit::Contract$},
      %r{^Kit::Pagination$},
    ],

    'JSON:API'   =>  [%r{^Kit::JsonApi.*}],

    'Contract'   => [%r{^Kit::Contract.*}],
    'Organizer'  => [%r{^Kit::Organizer.*}],
    'Pagination' => [%r{^Kit::Pagination.*}],
  }
end

# Check that the version is a Git tag, otherwise for now, assume this is edge.
def get_documentation_version(version:, source_url:)
  path     = File.expand_path('..', __dir__)
  g        = Git.open(path)
  tag_name = "v#{ version }"

  if g.tags.include?(tag_name)
    source_ref       = tag_name
    code_version_ref = tag_name
  else
    source_ref       = 'edge'
    code_version_ref = g.log.first.objectish
  end

  {
    source_ref: source_ref,
    repo_url:   "#{ source_url }/blob/#{ code_version_ref }",
  }
end

def docs_config(project:, version:, source_url:, authors: [])
  data = {
    project:            project,
    version:            version,
    source_url:         source_url,
    authors:            authors,

    output_dir:         'docs/dist',
    documentation_url:  '',

    logo:               'assets/images/logo.v1.svg',
    extra_section:      'Guides',
    assets:             'guides/assets',
    main:               'overview',

    main_redirect_url:  'Kit.html',

    files_modules:      files_modules,
    groups_for_modules: groups_for_modules,
    files_extras:       files_extras,
    groups_for_extras:  groups_for_extras,
  }

  data.merge!(get_documentation_version(version: version, source_url: source_url))

  data[:output_dir] += "/#{ data[:source_ref] }"

  data
end

YARD::Rake::YardocTask.new do |t|
  t.name = 'documentation:yardoc:all'

  gemspec_file = '../kit.gemspec'
  gemspec_path = File.expand_path(gemspec_file, __dir__)
  gemspec_data = eval(File.read(gemspec_path), binding, gemspec_path)

  config = docs_config({
    project:    gemspec_data.name,
    version:    gemspec_data.version,
    source_url: gemspec_data.metadata['source_code_base_uri'],
    authors:    [gemspec_data.author],
  })

  t.before = -> do
    Kit::Doc::Services::Config.config = config

    FileUtils.rm_rf(Dir[config[:output_dir] + '/*'])
  end

  t.files = (config[:files_modules] + ['-'] + config[:files_extras]).flatten

  t.options = [
    '--output-dir',      config[:output_dir],
    '--plugin',          'kit-doc-yard', 'kit-doc-yard-contracts', # Redundant with `.yardopts`?
    '--asset',           'docs/assets:assets/images',
    '--markup-provider', 'redcarpet',
    '--markup',          'markdown',
  ]
end
