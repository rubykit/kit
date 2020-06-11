require 'yard'
require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.get_default_config(
  gemspec_name:       'kit',

  project_path:       File.expand_path('..', __dir__),
  git_project_path:   File.expand_path('..', __dir__),
  output_dir_base:    ENV['KIT_DOC_OUTPUT_DIR_BASE'].presence || 'docs/dist/kit',
  source_ref:         ENV['KIT_DOC_SOURCE_REF'].presence,
  version:            ENV['KIT_DOC_VERSION'].presence || 'dev',
  versions:           Kit::Doc::Services::Config.load_versions_file(path: File.expand_path('../docs/VERSIONS', __dir__))[1][:versions],

  main_redirect_url:  'file.overview.html',
  logo:               'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

  files_modules:      [],
  groups_for_modules: {},

  files_extras:       Kit::Doc::Services::Tasks.resolve_files(hash: {
    'docs/guides' => {
      include: %w[
        **/*.md
      ],
    },
  }),
  groups_for_extras:  {
    'Introduction' => [%r{guides/introduction/.?}],
    'Guides'       => [%r{guides/[^/]+.md}],
    'Architecture' => [%r{guides/architecture/.?}],
    'Various'      => [%r{guides/various/.?}],
  },
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

namespace :documentation do
  namespace :generate do
    namespace :all_versions do

      # Use the first version in config[:versions] as the default.
      task :generate_global_assets do
        default_version  = DOC_CONFIG[:versions][0][:version]
        destination_path = File.expand_path('../docs/dist', __dir__)

        Kit::Doc::Services::Tasks.generate_html_redirect_file(
          dst:          File.join(destination_path, 'index.html'),
          title:        'Rubykit Documentation',
          redirect_url: "kit/#{ default_version }/index.html",
        )
      end

    end
  end
end
