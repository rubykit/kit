require 'yard'
require 'yard-kit'
require 'rubygems'
require 'git'

require 'pry'

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
end

def files_extras
  FILES_EXTRA
    .map do |lib_path, data|
      (data[:include] || []).map { |path| Dir["#{ lib_path }/#{ path }"] }
    end
end

def groups_for_extras
  {
    'Introduction' => %r{/guides\/introduction\/.?/},
    'Architecture' => %r{/guides\/architecture\/.?/},
    'Various'      => %r{/guides\/various\/.?/},
  }
end

def groups_for_modules
  {
    #'Testing' => [],
    'Code flow' => [
      'Kit::Organizer',
      'Kit::Contracts',
    ],
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

def docs_config(project:, version:, output_dir:, source_url:, documentation_url:, authors: [], logo:)
  data = {
    project:            project,
    version:            version,
    documentation_url:  documentation_url,
    source_url:         source_url,
    output_dir:         output_dir,
    authors:            authors,

    logo:               logo,
    extra_section:      'GUIDES',
    assets:             'guides/assets',
    main:               'overview',

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
    project:           gemspec_data.name,
    version:           gemspec_data.version,
    output_dir:        'docs/dist',
    source_url:        gemspec_data.metadata['source_code_base_uri'],
    documentation_url: 'file:///Users/nathan/rubykit/repositories/kit/docs/dist/edge',
    authors:           [gemspec_data.author],
    logo:              'images/logo.v1.svg',
  })

  t.before = -> do
    Yard::Kit::Config.config = config
  end

  t.files = (config[:files_modules] + ['-'] + config[:files_extras]).flatten

  t.options = [
    '--output-dir',      config[:output_dir],
    '--plugin',          'yard-kit', 'contracts', # Redundant with `.yardopts`?
    '--asset',           'docs/assets:images',
    '--markup-provider', 'redcarpet',
    '--markup',          'markdown',
  ]
end
