require 'yard'
require 'yard-kit'

FILES_MODULES = {
  'specs/dummy/'   => {
    include: %w[
      kat.rb
    ],
  },
  'specs/dummy/kat/'  => {
    include: %w[
      **/*.rb
    ],
  },
}

FILES_EXTRA = {
  'spec/dummy/guides' => {
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
    'Derived Nodes' => [
      'Kat::ChildNode',
      'Kat::ChildChildNode',
    ],
    'Services'      => [
      'Kat::Service',
    ],
  }
end

YARD::Rake::YardocTask.new do |t|
  t.name = 'specs:docs:dummy-app'

  config = {
    project:            'Dummy',
    version:            '1.0.2',
    source_url:         'https://github.com/rubykit/yard-kit',
    authors:            ['John Doe'],
    logo:               'https://avatars2.githubusercontent.com/u/63779174?s=200&v=4',

    output_dir:         'specs/dummy/docs/v1.0.2',

    source_ref:         'v1.0.2',
    repo_url:           'https://github.com/rubykit/yard-kit/blob/v1.0.2',
    homepage_url:       'http://localhost',

    main:               'overview',
    extra_section:      'GUIDES',
    assets:             'guides/assets',
    files_modules:      files_modules,
    groups_for_modules: groups_for_modules,
    files_extras:       files_extras,
    groups_for_extras:  groups_for_extras,

  }

  Yard::Kit::Config.config = config

  t.files = (config[:files_modules] + ['-'] + config[:files_extras]).flatten

  t.options = [
    '--output-dir',      config[:output_dir],
    '--plugin',          'yard-kit', 'contracts', # Redundant with `.yardopts`?
    '--markup-provider', 'redcarpet',
    '--markup',          'markdown',
  ]
end