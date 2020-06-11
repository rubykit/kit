require 'yard'
require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.get_default_config(
  project:            'Kat',

  project_path:       File.expand_path('..', __dir__),
  git_project_path:   File.expand_path('../../..', __dir__),
  output_dir_base:    'specs/dummy/docs/dist/kat',
  source_ref:         'master',
  version:            'edge',
  versions:           [{ version: 'edge', source_ref: 'master' }],

  main_redirect_url:  'file.neu_dixi_raptam.html',

  source_url:         'https://github.com/rubykit/kit/tree/master/libraries/kit-doc',
  documentation_url:  'http://localhost',

  authors:            ['John Doe'],
  logo:               'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

  files_modules:      Kit::Doc::Services::Tasks.resolve_files(hash: {
    'specs/dummy/' => {
      include: %w[
        kat.rb
        kat/**/*.rb
        mixins/*.rb
      ],
    },
  }),
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

  files_extras:       Kit::Doc::Services::Tasks.resolve_files(hash: {
    'specs/dummy/docs/guides' => {
      include: %w[
        **/*.md
      ],
    },
  }),
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
  task_name:        'specs:dummy-app:documentation:generate',
  config:           DOC_CONFIG,
  clean_output_dir: true,
})

YARD::Rake::YardocTask.new do |t|
  output_dir = "specs/dummy/docs/dist/kat-raw/#{ DOC_CONFIG[:version] }"

  t.name     = 'specs:dummy-app:documentation:generate:raw'
  t.before   = -> do
    # Disable the plugin in a hacky way
    YARD::Templates::Engine.template_paths.pop

    FileUtils.rm_rf(Dir[output_dir + '/*'])
  end

  t.files    = (DOC_CONFIG[:files_modules] + ['-'] + DOC_CONFIG[:files_extras]).flatten

  t.options  = [
    '--output-dir',      output_dir,
    '--markup-provider', 'redcarpet',
    '--markup',          'markdown',
    '--private',
    '--protected',
  ]
end
