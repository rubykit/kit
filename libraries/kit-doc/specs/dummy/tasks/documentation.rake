require 'yard'
require 'kit-doc'

DOC_CONFIG_DUMMY_APP = Kit::Doc::Services::Config.get_default_config(
  project:                 'kat',

  project_path:            File.expand_path('..', __dir__),
  git_project_path:        File.expand_path('../../../../..', __dir__),
  output_dir_all_versions: ENV['KIT_DOC_OUTPUT_DIR_ALL_VERSIONS'].presence || 'docs/dist/kat',
  source_ref:              ENV['KIT_DOC_SOURCE_REF'].presence,
  current_version:         ENV['KIT_DOC_CURRENT_VERSION'].presence,
  all_versions:            File.expand_path('../docs/VERSIONS', __dir__),

  source_url:              'https://github.com/rubykit/kit/tree/master/libraries/kit-doc',
  authors:                 ['John Doe'],

  main_redirect_url:       'ab_colla_deus.html',
  logo:                    'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

  files_modules:           Kit::Doc::Services::Tasks::Helpers.resolve_files(hash: {
    'specs/dummy/' => {
      include: %w[
        kat.rb
        kat/**/*.rb
        mixins/*.rb
      ],
    },
  }),
  groups_for_modules:      {
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

  files_extras:            Kit::Doc::Services::Tasks::Helpers.resolve_files(hash: {
    'specs/dummy/docs/guides' => {
      include: %w[
        **/*.md
      ],
    },
  }),
  groups_for_extras:       {
    'Introduction' => [%r{guides/f1/.?}],
    'Architecture' => [%r{guides/f2/.?}],
    'Important'    => [
      %r{guides/f1/neu},
      %r{guides/f2/sub},
    ],
  },
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!({
  task_name:        'specs:dummy-app:documentation:generate',
  config:           DOC_CONFIG_DUMMY_APP,
  clean_output_dir: true,
})

Kit::Doc::Services::Tasks.create_rake_task_documentation_all_versions!({
  task_namespace: 'specs:dummy-app:documentation:all_versions',
  config:         DOC_CONFIG_DUMMY_APP,
})

YARD::Rake::YardocTask.new do |t|
  output_dir = "specs/dummy/docs/dist/kat-raw/#{ DOC_CONFIG_DUMMY_APP[:version] }"

  t.name     = 'specs:dummy-app:documentation:generate:raw'
  t.before   = -> do
    # Disable the plugin in a hacky way
    ::YARD::Templates::Engine.template_paths.pop
    # Disable Redcarpet custom renderer
    ::RedcarpetCompat.disabled = true
    # Overwrite `Kit::Doc::Yard::FileSerializer`
    ::YARD::CLI::YardocOptions.default_attr :serializer, -> { ::YARD::Serializers::FileSystemSerializer.new }

    FileUtils.rm_rf(Dir[output_dir + '/*'])
  end

  t.files    = (DOC_CONFIG_DUMMY_APP[:files_modules] + ['-'] + DOC_CONFIG_DUMMY_APP[:files_extras]).flatten

  t.options  = [
    '--output-dir',      output_dir,
    '--markup-provider', 'redcarpet',
    '--markup',          'markdown',
    '--private',
    '--protected',
  ]
end
