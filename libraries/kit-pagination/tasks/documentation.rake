require 'yard'
require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.get_default_config(
  gemspec_name:            'kit-pagination',

  project_path:            File.expand_path('..', __dir__),
  git_project_path:        File.expand_path('../../..', __dir__),
  output_dir_all_versions: ENV['KIT_DOC_OUTPUT_DIR_ALL_VERSIONS'].presence || 'docs/dist/kit-pagination',
  source_ref:              ENV['KIT_DOC_SOURCE_REF'].presence,
  current_version:         ENV['KIT_DOC_CURRENT_VERSION'].presence || 'dev',
  all_versions:            File.expand_path('../docs/VERSIONS', __dir__),

  main_redirect_url:       'Kit/Pagination.html',

  logo:                    'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

  files_modules:           Kit::Doc::Services::Tasks::Helpers.resolve_files(hash: {
    './' => {
      include: %w[
        lib/**/*.rb
        app/**/*.rb
      ],
    },
  }),
  groups_for_modules:      {
    '' => [
      {
        inclusion: %r{^(Kit)$},
        display:   false,
      },
    ],
  },

  files_extras:            Kit::Doc::Services::Tasks::Helpers.resolve_files(hash: {
    'docs/guides' => {
      include: %w[
        **/*.md
      ],
    },
  }).sort,
  groups_for_extras:       {},
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!({
  task_name:        'documentation:generate',
  config:           DOC_CONFIG,
  clean_output_dir: true,
})

Kit::Doc::Services::Tasks.create_rake_task_documentation_all_versions!({
  task_namespace: 'documentation:all_versions',
  config:         DOC_CONFIG,
})
