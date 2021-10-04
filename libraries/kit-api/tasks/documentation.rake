require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.create_config(
  gemspec_name:       'kit-api',

  project_path:       File.expand_path('..', __dir__),
  git_project_path:   File.expand_path('../../..', __dir__),
  all_versions:       File.expand_path('../docs/VERSIONS', __dir__),

  main_redirect_url:  'README.html',

  logo:               'https://raw.githubusercontent.com/rubykit/kit/main/docs/assets/images/rubykit-framework-logo.svg',

  files_modules:      {
    './' => {
      include: %w[
        lib/**/*.rb
        app/**/*.rb
        spec/dummy/app/resources/kit/json_api_spec/resources/*.rb
      ],
    },
  },
  groups_for_modules: {
    ''                  => [
      {
        inclusion: %r{^(Kit|Kit::Api|Kit::Api::Resources|Kit::Api::Services|Kit::Api::JsonApi::Services)$},
        display:   false,
      },
    ],
    'Api'               => [
      {
        inclusion:     %r{^(Kit::Api::Contracts|Kit::Api::Resources::ActiveRecordResource)$},
        display_title: ->(name) { name.gsub('Kit::Api::', '') },
      },
    ],
    'Api Services'      => [
      {
        inclusion:     %r{^Kit::Api::Services::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Api::Services::'),
      },
    ],
    'Json:Api'          => [
      {
        inclusion:     %r{^(Kit::Api::JsonApi::Contracts|Kit::Api::JsonApi::Controllers.*)$},
        display_title: ->(name) { name.gsub('Kit::Api::JsonApi::', '') },
      },
    ],
    'Json:Api Services' => [
      {
        inclusion:     %r{^Kit::Api::JsonApi::Services::.*},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
        css_classes:   Kit::Doc::Services::Tasks::Helpers.display_css_padding(hide: 'Kit::Api::JsonApi::Services::'),
      },
    ],
    'Various'           => [
      {
        inclusion:     %r{^Kit::Api::(Engine|Railtie)},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
      },
    ],
    'Exemple resources' => [
      {
        inclusion:     %r{^Kit::JsonApiSpec::Resources::},
        display_title: Kit::Doc::Services::Tasks::Helpers.display_last_name,
      },
    ],
  },

  files_extras:       {
    '.'           => { include: %w[README.md] },
    'docs/guides' => { include: %w[**/*.md] },
  },
  groups_for_extras:  {
    'JSON:API' => [%r{guides/jsonapi_support.md}],
    'GraphQL'  => [%r{guides/graphql_support.md}],
  },

  assets:             [
    [File.expand_path('../docs/guides/assets', __dir__), 'assets'],
  ],
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!(
  config:           DOC_CONFIG,
  clean_output_dir: true,
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_all_versions!(
  config: DOC_CONFIG,
)
