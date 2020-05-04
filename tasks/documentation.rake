require 'yard'
require 'kit-doc-yard'
require 'rubygems'
require 'git'
require 'json'

require_relative '../version'

FILES_MODULES = {
  'libraries/kit-json-api'   => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
  'libraries/kit-organizer'  => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
  'libraries/kit-pagination' => {
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

def load_gemspec_data
  gemspec_file = '../kit.gemspec'
  gemspec_path = File.expand_path(gemspec_file, __dir__)
  gemspec_data = eval(File.read(gemspec_path), binding, gemspec_path)

  gemspec_data
end

OUTPUT_DIR = 'docs/dist'

def docs_config(project:, version:, source_url:, documentation_url:, authors: [])
  data = {
    project:            project,
    version:            version,
    source_url:         source_url,
    authors:            authors,

    documentation_url:  documentation_url,

    output_dir:         OUTPUT_DIR,

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

  if data[:source_ref] == 'edge'
    data[:documentation_url] = data[:documentation_url].gsub("v#{ data[:version] }", 'edge')
    data[:version]           = 'edge'
  end

  data[:output_dir] += "/#{ data[:source_ref] }"

  data
end

YARD::Rake::YardocTask.new do |t|
  t.name = 'documentation:yardoc:all'

  gemspec_data = load_gemspec_data

  config = docs_config({
    project:           gemspec_data.name,
    version:           gemspec_data.version,
    source_url:        gemspec_data.metadata['source_code_base_uri'],
    documentation_url: gemspec_data.metadata['documentation_uri'],
    authors:           [gemspec_data.author],
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

namespace :documentation do
  task :generate_global_dist_assets do
    gemspec_data = load_gemspec_data

    to = File.expand_path('../docs/dist', __dir__)
    FileUtils.cp(File.expand_path('../docs/assets/top_level_index.html', __dir__), File.join(to, 'index.html'))

    dir_list = Dir[File.join(to, '*')]
      .select { |el| File.directory?(el) }
      .map    { |el| Pathname.new(el).basename.to_s }

    documentation_uri = gemspec_data.metadata['documentation_uri']
    versions_list = dir_list.map do |el|
      {
        version: el,
        url:     documentation_uri.gsub("v#{ gemspec_data.version }", el),
      }
    end

    file_content = "var versionNodes = #{ JSON.pretty_generate(versions_list) };"

    File.open(File.join(to, 'docs_config.js'), 'w') { |file| file.write(file_content) }
  end
end
