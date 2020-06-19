require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.create_config(
  gemspec_name:       'kit-contract',

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
    ''                   => [
      {
        inclusion: %r{^(Kit|Kit::Contract::Services)$},
        display:   false,
      },
    ],
    'Services'           => [
      {
        inclusion:     %r{^Kit::Contract::Services::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Contract::Services::'),
      },
    ],
    'Built-in Contracts' => [
      {
        inclusion:     %r{^Kit::Contract::BuiltInContracts::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Contract::BuiltInContracts::'),
      },
    ],
    'Various'            => [
      {
        inclusion:     %r{^Kit::Contract::(Engine|Railtie)},
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
