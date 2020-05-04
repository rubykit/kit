require 'yard'
require 'kit-doc-yard'

FILES_MODULES = {
  'specs/dummy/' => {
    include: %w[
      kat.rb
      kat/**/*.rb
      mixins/*.rb
    ],
  },
}

FILES_EXTRA = {
  'specs/dummy/docs/guides' => {
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
    'Introduction' => [%r{guides/f1/.?}],
    'Architecture' => [%r{guides/f2/.?}],
    'Important'    => [
      %r{guides/f1/ab},
      %r{guides/f2/sub},
    ],
  }
end

def groups_for_modules
  {
    ''         => [
      %r{^Kat$},
    ],
    'Node'     => [
      %r{^Kat::Child*},
    ],
    'Services' => [
      %r{^Kat::Service*},
    ],
    'Mixins'   => [
      %r{^Class*},
    ],
    'All Kat'  => [
      %r{^Kat::},
    ],
  }
end

def generate_config(output_dir:)
  {
    project:            'Kat',
    version:            '1.0.2',
    source_url:         'https://github.com/rubykit/kit/tree/master/kit/libs/kit-doc-yard',
    authors:            ['John Doe'],
    logo:               'https://avatars2.githubusercontent.com/u/63779174?s=200&v=4',

    output_dir:         output_dir,

    source_ref:         'v1.0.2',
    repo_url:           'https://github.com/rubykit/kit/blob/v1.0.2',
    documentation_url:  'http://localhost',

    main_redirect_url:  'file.neu_dixi_raptam.html',
    extra_section:      'GUIDES',
    assets:             'guides/assets',
    files_modules:      files_modules,
    groups_for_modules: groups_for_modules,
    files_extras:       files_extras,
    groups_for_extras:  groups_for_extras,
  }
end

YARD::Rake::YardocTask.new do |t|
  t.name = 'specs:docs:dummy-app'

  config = generate_config(
    output_dir: 'specs/dummy/docs/dist/1.0.2',
  )

  t.before = -> do
    Kit::Doc::Services::Config.config = config

    FileUtils.rm_rf(Dir[config[:output_dir] + '/*'])
  end

  t.files = (config[:files_modules] + ['-'] + config[:files_extras]).flatten

  t.options = [
    '--output-dir',      config[:output_dir],
    '--plugin',          'kit-doc-yard', 'kit-doc-yard-contracts', # Redundant with `.yardopts`?
    '--markup-provider', 'redcarpet',
    '--markup',          'markdown',
  ]
end

YARD::Rake::YardocTask.new do |t|
  t.name = 'specs:docs:dummy-app:raw'

  config = generate_config(
    output_dir: 'specs/dummy/docs/dist/raw',
  )

  t.before = -> do
    # Disable plugin in a hacky way
    YARD::Templates::Engine.template_paths.pop

    FileUtils.rm_rf(Dir[config[:output_dir] + '/*'])
  end

  t.files = (config[:files_modules] + ['-'] + config[:files_extras]).flatten

  t.options = [
    '--output-dir',      config[:output_dir],
    '--markup-provider', 'redcarpet',
    '--markup',          'markdown',
    '--private',
    '--protected',
  ]
end
