require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.create_config(
  gemspec_name:       'kit-auth',

  project_path:       File.expand_path('..', __dir__),
  git_project_path:   File.expand_path('../../..', __dir__),
  all_versions:       File.expand_path('../docs/VERSIONS', __dir__),

  main_redirect_url:  'README.html',

  logo:               'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

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
        inclusion: %r{^(Kit|Kit::Auth::Services)$},
        display:   false,
      },
    ],

    'Services'     => [
      {
        inclusion:     %r{^Kit::Auth::Services::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Auth::Services::'),
      },
    ],
    'Actions'      => [
      {
        inclusion:     %r{^Kit::Auth::Actions::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Auth::Actions::'),
      },
    ],
    'Models'       => [
      {
        inclusion:     %r{^Kit::Auth::Models::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Auth::Models::'),
      },
    ],
    'Controllers'  => [
      {
        inclusion:     %r{^Kit::Auth::Controllers::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Auth::Controllers::'),
      },
    ],
    'Admin'        => [
      {
        inclusion:     %r{^Kit::Auth::Admin::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Auth::Admin::'),
      },
    ],
    'Components'   => [
      {
        inclusion:     %r{^Kit::Auth::Components::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Auth::Components::'),
      },
    ],
    'View Helpers' => [
      {
        inclusion:     %r{^Kit::Auth::ViewHelpers::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Auth::ViewHelpers::'),
      },
    ],
    'Various'      => [
      {
        inclusion:     %r{^Kit::Auth::(Engine|Railtie)},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
      },
    ],
  },

  files_extras:       {
    '.'           => { include: %w[README.md] },
    'docs/guides' => { include: %w[**/*.md] },
  },

)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!({
  config:           DOC_CONFIG,
  clean_output_dir: true,
})

Kit::Doc::Services::Tasks.create_rake_task_documentation_all_versions!({
  config: DOC_CONFIG,
})
