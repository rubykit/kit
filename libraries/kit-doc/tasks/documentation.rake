require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.create_config(
  gemspec_name:            'kit-doc',

  project_path:            File.expand_path('..', __dir__),
  git_project_path:        File.expand_path('../../..', __dir__),
  output_dir_all_versions: ENV['KIT_DOC_OUTPUT_DIR_ALL_VERSIONS'].presence || 'docs/dist/kit-doc',
  all_versions:            File.expand_path('../docs/VERSIONS', __dir__),

  main_redirect_url:       'README.html',
  logo:                    'https://raw.githubusercontent.com/rubykit/kit/master/libraries/kit-doc/docs/assets/images/kit-doc.logo.svg',

  files_modules:           {
    './' => {
      include: %w[
        lib/**/*.rb
        app/**/*.rb
      ],
    },
  },
  groups_for_modules:      {
    ''          => [
      {
        inclusion: %r{^(Kit|Kit::Doc|Kit::Doc::Redcarpet|Kit::Doc::Services)$},
        display:   false,
      },
    ],
    'Services'  => [
      {
        inclusion:     %r{^Kit::Doc::Services::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Doc::Services::'),
      },
    ],
    'Overrides' => [
      {
        inclusion:     %r{^(RedcarpetCompat|YARD.*|Kit::Doc::RedcarpetRenderCustom|Kit::Doc::Yard.*)$},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Doc::'),
      },
    ],
    'Various'   => [
      {
        inclusion:     %r{^Kit::Doc::(Engine|Railtie)},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
      },
    ],
  },

  files_extras:            {
    '.'           => {
      include: %w[
        README.md
      ],
    },
    'docs/guides' => {
      include: %w[
        **/*.md
      ],
    },
  },
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!(
  config:           DOC_CONFIG,
  clean_output_dir: true,
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_all_versions!(
  config: DOC_CONFIG,
)
