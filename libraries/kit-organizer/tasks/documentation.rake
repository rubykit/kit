require 'yard'
require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.get_default_config(
  gemspec_name:       'kit-organizer',

  project_path:       File.expand_path('..', __dir__),
  git_project_path:   File.expand_path('../../..', __dir__),
  output_dir_base:    ENV['KIT_DOC_OUTPUT_DIR_BASE'].presence || 'docs/dist/kit-organizer',
  source_ref:         ENV['KIT_DOC_SOURCE_REF'].presence,
  version:            ENV['KIT_DOC_VERSION'].presence || 'dev',
  versions:           Kit::Doc::Services::Config.load_versions_file(path: File.expand_path('../docs/VERSIONS', __dir__))[1][:versions],

  main_redirect_url:  'Kit/Organizer.html',

  logo:               'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

  files_modules:      Kit::Doc::Services::Tasks.resolve_files(hash: {
    './' => {
      include: %w[
        lib/**/*.rb
        app/**/*.rb
      ],
    },
  }),
  groups_for_modules: {
    ''         => [
      {
        inclusion: %r{^(Kit|Kit::Organizer::Services)$},
        display:   false,
      },
    ],
=begin
    'Contracts' => [
      {
        inclusion:     %r{^Kit::Organizer::Contracts.*},
        display_title: Kit::Doc::Services::Tasks.display_helper_last_name,
        css_classes:   Kit::Doc::Services::Tasks.display_helper_css_padding(hide: 'Kit::Organizer::'),
      },
    ],
=end
    'Services' => [
      {
        inclusion:     %r{^Kit::Organizer::Services::.*},
        display_title: Kit::Doc::Services::Tasks.display_helper_last_name,
        css_classes:   Kit::Doc::Services::Tasks.display_helper_css_padding(hide: 'Kit::Organizer::Services::'),
      },
    ],
    'Various'  => [
      {
        inclusion:     %r{^Kit::Organizer::(Engine|Railtie)},
        display_title: Kit::Doc::Services::Tasks.display_helper_last_name,
      },
    ],
  },

  files_extras:       Kit::Doc::Services::Tasks.resolve_files(hash: {
    'docs/guides' => {
      include: %w[
        **/*.md
      ],
    },
  }).sort,
  groups_for_extras:  {},
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!({
  task_name:        'documentation:generate',
  config:           DOC_CONFIG,
  clean_output_dir: true,
})

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate_all_versions!({
  task_name: 'documentation:generate:all_versions',
  config:    DOC_CONFIG,
})
