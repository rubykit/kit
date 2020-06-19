require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.create_config(
  gemspec_name:            'kit',

  project_path:            File.expand_path('..', __dir__),
  git_project_path:        File.expand_path('..', __dir__),
  output_dir_all_versions: ENV['KIT_DOC_OUTPUT_DIR_ALL_VERSIONS'].presence || 'docs/dist/kit',
  all_versions:            File.expand_path('../docs/VERSIONS', __dir__),

  main_redirect_url:       'README.html',
  logo:                    'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

  files_modules:           [],
  groups_for_modules:      {},

  files_extras:            {
    '.'           => { include: %w[README.md] },
    #'docs/guides' => { include: %w[**/*.md] },
  },
  groups_for_extras:       {
    'Introduction' => [%r{guides/introduction/.?}],
    'Guides'       => [%r{guides/[^/]+.md}],
    'Architecture' => [%r{guides/architecture/.?}],
    'Various'      => [%r{guides/various/.?}],
  },
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!({
  config:           DOC_CONFIG,
  clean_output_dir: true,
})

Kit::Doc::Services::Tasks.create_rake_task_documentation_all_versions!({
  config: DOC_CONFIG,
})

namespace :documentation do
  namespace :all_versions do
    namespace :generate do
      # Use the first version in config[:versions] as the default.
      task :global_assets do
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
