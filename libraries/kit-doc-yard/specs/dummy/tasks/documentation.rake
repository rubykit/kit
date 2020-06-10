require 'yard'
require 'kit-doc-yard'

FILES_MODULES = Kit::Doc::Services::Tasks.resolve_files(hash: {
  'specs/dummy/' => {
    include: %w[
      kat.rb
      kat/**/*.rb
      mixins/*.rb
    ],
  },
})

FILES_EXTRAS = Kit::Doc::Services::Tasks.resolve_files(hash: {
  'specs/dummy/docs/guides' => {
    include: %w[
      **/*.md
    ],
  },
})

CONFIG = Kit::Doc::Services::Config.get_default_config(
  project:            'Kat',
  version:            'edge',
  source_url:         'https://github.com/rubykit/kit/tree/master/libraries/kit-doc-yard',
  authors:            ['John Doe'],
  logo:               'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

  source_ref:         'edge',
  repo_url:           'https://github.com/rubykit/kit/tree/master/libraries/kit-doc-yard/specs/dummy',
  documentation_url:  'http://localhost',

  main_redirect_url:  'file.neu_dixi_raptam.html',

  output_dir:         'specs/dummy/docs/dist/edge',

  files_modules:      FILES_MODULES,
  groups_for_modules: {
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
  },

  files_extras:       FILES_EXTRAS,
  groups_for_extras:  {
    'Introduction' => [%r{guides/f1/.?}],
    'Architecture' => [%r{guides/f2/.?}],
    'Important'    => [
      %r{guides/f1/ab},
      %r{guides/f2/sub},
    ],
  },
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!({
  task_name:        'specs:docs:dummy-app',
  config:           CONFIG,
  clean_output_dir: true,
})

YARD::Rake::YardocTask.new do |t|
  output_dir = 'specs/dummy/docs/dist/raw'

  t.name     = 'specs:docs:dummy-app:raw'
  t.before   = -> do
    # Disable the plugin in a hacky way
    YARD::Templates::Engine.template_paths.pop

    FileUtils.rm_rf(Dir[output_dir + '/*'])
  end

  t.files    = (FILES_MODULES + ['-'] + FILES_EXTRAS).flatten

  t.options  = [
    '--output-dir',      output_dir,
    '--markup-provider', 'redcarpet',
    '--markup',          'markdown',
    '--private',
    '--protected',
  ]
end
