require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.create_config(
  gemspec_name:       'kit-router',

  project_path:       File.expand_path('..', __dir__),
  git_project_path:   File.expand_path('../../..', __dir__),
  all_versions:       File.expand_path('../docs/VERSIONS', __dir__),

  main_redirect_url:  'README.html',

  logo:               'https://raw.githubusercontent.com/rubykit/kit/master/libraries/kit-router/docs/assets/images/kit-router.logo.svg',

  files_modules:      {
    './' => {
      include: %w[
        lib/**/*.rb
        app/**/*.rb
      ],
    },
  },
  groups_for_modules: {
    ''             => [
      {
        inclusion: %r{^(Kit|Kit::Router::Services)$},
        display:   false,
      },
    ],

    'Services'     => [
      {
        inclusion:     %r{^Kit::Router::Services::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Router::Services::'),
      },
    ],
    'Models'       => [
      {
        inclusion:     %r{^Kit::Router::Models::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Router::Models::'),
      },
    ],
    'Controllers'  => [
      {
        inclusion:     %r{^Kit::Router::Controllers::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Router::Controllers::'),
      },
    ],
    'View Helpers' => [
      {
        inclusion:     %r{^Kit::Router::ViewHelpers::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Router::ViewHelpers::'),
      },
    ],
    'Various'      => [
      {
        inclusion:     %r{^Kit::Router::(Engine|Railtie)},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
      },
    ],
  },

  files_extras:       {
    '.'           => { include: %w[README.md] },
    'docs/guides' => { include: %w[**/*.md] },
  },

)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!(
  config:           DOC_CONFIG,
  clean_output_dir: true,
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_all_versions!(
  config: DOC_CONFIG,
)
