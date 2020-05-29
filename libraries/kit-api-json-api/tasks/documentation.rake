require 'yard'
require 'kit-doc-yard'

css_padding_helper = ->(text) do
  ->(name) do
    #size = name.gsub(text, '').gsub(%r{^::}, '').scan('::').size
    size = name.gsub(text, '').scan('::').size
    ["#{ (size > 0) ? "sidebar-pl-#{ size }" : '' }"]
  end
end
display_title_last = ->(name) { name.split('::')[-1] }

CONFIG = Kit::Doc::Services::Tasks.get_default_config(
  gemspec_name:       'kit-api-json-api',
  git_project_path:   File.expand_path('../../..', __dir__),
  output_dir_base:    'docs/dist',

  main_redirect_url:  'Kit/Api/JsonApi.html',

  logo:               'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

  files_modules:      Kit::Doc::Services::Tasks.resolve_files(hash: {
    './' => {
      include: %w[
        lib/**/*.rb
        app/**/*.rb
        spec/dummy/app/resources/kit/json_api_spec/resources/*.rb
      ],
    },
  }),
  groups_for_modules: {
    ''                  => [
      {
        inclusion: %r{^(Kit|Kit::Api)$},
        display:   false,
      },
      {
        inclusion:     %r{^(Kit::Api::JsonApi::Controllers::JsonApi|Kit::Api::JsonApi::Resources::ActiveRecordResource|Kit::Api::JsonApi::Services|Kit::Api::JsonApi::Contracts)$},
        display_title: ->(name) { name.gsub('Kit::Api::JsonApi::', '') },
        css_classes:   ['sidebar-pl-1'],
      },
    ],
    'Services'          => [
      {
        inclusion:     %r{^Kit::Api::JsonApi::Services::.*},
        display_title: display_title_last,
        css_classes:   css_padding_helper.call('Kit::Api::JsonApi::Services::'),
      },
    ],
    'Various'           => [
      {
        inclusion:     %r{^Kit::Api::JsonApi::(Engine|Railtie)},
        display_title: display_title_last,
      },
    ],
    'Exemple resources' => [
      {
        inclusion:     %r{^Kit::JsonApiSpec::Resources::},
        display_title: display_title_last,
      },
    ],
  },

  files_extras:       Kit::Doc::Services::Tasks.resolve_files(hash: {
    'docs/guides' => {
      include: %w[
        **/*.md
      ],
    },
  }),
  groups_for_extras:  {},

  assets:             [
    [File.expand_path('../docs/assets', __dir__), 'assets'],
  ],
)

Kit::Doc::Services::Tasks.create_rake_documentation_task!({
  task_name:        'documentation:yardoc',
  config:           CONFIG,
  clean_output_dir: true,
})
