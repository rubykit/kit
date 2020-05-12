require 'yard'
require 'kit-doc-yard'

DOC_CONFIG = Kit::Doc::Services::Tasks.get_default_config(
  gemspec_name:       'kit',
  git_project_path:   File.expand_path('..', __dir__),
  output_dir_base:    'docs/dist',

  main_redirect_url:  'Kit.html',
  logo:               'https://raw.githubusercontent.com/rubykit/kit/master/docs/assets/images/rubykit-framework-logo.svg',

  files_modules:      Kit::Doc::Services::Tasks.resolve_files(hash: {
    'libraries/kit-api-jsonapi' => {
      include: %w[
        lib/**/*.rb
        app/**/*.rb
      ],
    },
    'libraries/kit-organizer'   => {
      include: %w[
        lib/**/*.rb
        app/**/*.rb
      ],
    },
    'libraries/kit-pagination'  => {
      include: %w[
        lib/**/*.rb
        app/**/*.rb
      ],
    },
  }),
  groups_for_modules: {
    ''           => [
      %r{^Kit$},
    ],
    'Libs'       => [
      %r{^Kit::Organizer$},
      %r{^Kit::Api::JsonApi$},
      %r{^Kit::Contract$},
      %r{^Kit::Pagination$},
    ],

    'JSON:API'   => [%r{^Kit::Api::JsonApi.*}],

    'Contract'   => [%r{^Kit::Contract.*}],
    'Organizer'  => [%r{^Kit::Organizer.*}],
    'Pagination' => [%r{^Kit::Pagination.*}],
  },

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

Kit::Doc::Services::Tasks.create_rake_documentation_task!({
  task_name:        'documentation:yardoc:all',
  config:           DOC_CONFIG,
  clean_output_dir: true,
})

namespace :documentation do
  task :generate_global_dist_assets do
    gemspec_data = load_gemspec_data

    to = File.expand_path('../docs/dist', __dir__)
    FileUtils.cp(File.expand_path('../docs/assets/top_level_index.html', __dir__), File.join(to, 'index.html'))

    dir_list = Dir[File.join(to, '*')]
      .select { |el| File.directory?(el) }
      .map    { |el| Pathname.new(el).basename.to_s }

    documentation_uri = gemspec_data.metadata['documentation_uri']
    versions_list = dir_list.map do |el|
      {
        version: el,
        url:     documentation_uri.gsub("v#{ gemspec_data.version }", el),
      }
    end

    file_content = "var versionNodes = #{ JSON.pretty_generate(versions_list) };"

    File.open(File.join(to, 'docs_config.js'), 'w') { |file| file.write(file_content) }
  end
end
