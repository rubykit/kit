require 'rubygems'
require 'fileutils'
require 'git'

# Methods to add documentation Rake tasks to projects.
module Kit::Doc::Services::Tasks

  # Create a yard rake task used to generate documentation for the current version of a project, using `Kit::Doc::Yard` setup.
  #
  #   * `:config` - A `Kit::Doc` config object.
  #
  #   * `:task_name` - The name of the rake task.
  #     Defaults to 'documentation:generate'.
  #
  #   * `:clean_output_dir` - If `true`, it will run a recursive remove inside `:output_dir_current_version/*`.
  #     Defaults to `false` as it is potentially dangerous.
  #
  def self.create_rake_task_documentation_generate!(config:, task_name: 'documentation:generate', clean_output_dir: false)
    ::YARD::Rake::YardocTask.new do |t|
      t.name    = task_name

      t.before  = -> do
        Kit::Doc::Services::Config.config = config

        if clean_output_dir && !config[:output_dir_current_version].empty?
          FileUtils.rm_rf(Dir[config[:output_dir_current_version] + '/*'])
        end
      end

      t.files   = (config[:files_modules] + ['-'] + config[:files_extras]).flatten

      t.options = [
        '--output-dir',      config[:output_dir_current_version],
        '--plugin',          'kit-doc', 'kit-doc-contracts', # Redundant with `.yardopts`?
        '--markup-provider', 'redcarpet',
        '--markup',          'markdown',
      ]
    end
  end

  # Create various rake tasks to generate documentation and various assets for versions specified in `config[:all_versions]`.
  def self.create_rake_task_documentation_all_versions!(config:, task_namespace: 'documentation:all_versions')
    task_name_docs_config = "#{ task_namespace }:docs_config"
    create_rake_task_documentation_all_versions_docs_config!(
      config:    config,
      task_name: task_name_docs_config,
    )

    task_name_index = "#{ task_namespace }:index"
    create_rake_task_documentation_all_versions_index!(
      config:    config,
      task_name: task_name_index,
    )

    task_name_generate = "#{ task_namespace }:generate"
    create_rake_task_documentation_all_versions_generate!(
      config:                config,
      task_name:             task_name_generate,
      task_name_docs_config: task_name_docs_config,
      task_name_index:       task_name_index,
    )
  end

  # Create a rake task to generate documentation for versions specified in `config[:all_versions]`.
  def self.create_rake_task_documentation_all_versions_generate!(config:, task_name: 'documentation:all_versions:generate', task_name_docs_config: 'documentation:all_versions:generate:docs_config', task_name_index: 'documentation:all_versions:generate:index')
    known_versions = config[:all_versions].map { |el| el[:version] }.join(' ')

    ::Rake.application.last_description = "Generate documentation for known versions: #{ known_versions }"
    ::Rake::Task.define_task(task_name => [task_name_docs_config, task_name_index]) do
      puts "Generating documentation for `#{ config[:project] }`"
      if !config[:all_versions] || config[:all_versions].size == 0
        puts '  No versions provided.'
        exit
      end

      puts "  Versions: #{ config[:all_versions].map { |el| el[:version] }.join(' ') }"

      # Generate documentation for every given version.
      generate_documentation_all_versions(
        config:         config,
        before_version: ->(version:, source_ref:) { puts "  Generating version `#{ version }` (source_ref: `#{ source_ref }`)" },
        after_version:  ->(result:, **)           { puts result.gsub("\n", "\n    ") },
      )
    end
  end

  # Create a rake task to generate a `docs_config.js` file with all versions specified in `config[:all_versions]`.
  def self.create_rake_task_documentation_all_versions_docs_config!(config:, task_name: 'documentation:all_versions:generate:docs_config')
    known_versions = config[:all_versions].map { |el| el[:version] }.join(' ')

    ::Rake.application.last_description = "Generate `docs_config.js` file with known versions: #{ known_versions }"
    ::Rake::Task.define_task(task_name) do
      # Add `docs_config.js`
      generate_docs_config(config: config)
    end
  end

  # Create a rake task to generate an `index.html` file redirecting to the first version in `config[:all_versions]`.
  def self.create_rake_task_documentation_all_versions_index!(config:, task_name: 'documentation:all_versions:generate:index')
    ::Rake.application.last_description = "Generate `index.html` that redirects to first known version: #{ config[:all_versions][0][:version] }"
    ::Rake::Task.define_task(task_name) do
      # Add top level `index.html` redirect file. Use the first value of config[:all_versions] as the default.
      generate_html_redirect_file(
        dst:          File.join(config[:output_dir_all_versions], 'index.html'),
        title:        "#{ config[:project] } documentation",
        redirect_url: "#{ config[:all_versions][0][:version] }/index.html",
      )
    end
  end

  # Run `rake documentation:generate` for all `config[:all_versions]` after checking out the git reference.
  def self.generate_documentation_all_versions(config:, before_version: nil, after_version: nil)
    # Save current current git reference
    initial_git_ref = Git.open(config[:git_project_path]).current_branch

    config[:all_versions].each do |version:, source_ref:|
      before_version.call(version: version, source_ref: source_ref) if before_version&.respond_to?(:call)

      result = %x(
        # Go back to the git top level directory for checkout
        cd "#{ config[:git_project_path] }"

        # Checkout the tag (or branch)
        git checkout --quiet #{ source_ref }

        # Back to the project dir
        cd #{ config[:project_path] }

        # Install deps for this version
        bundle install

        # Generate documentation files
        KIT_DOC_OUTPUT_DIR_BASE=#{ config[:output_dir_all_versions] } KIT_DOC_CURRENT_VERSION=#{ version } KIT_DOC_SOURCE_REF=#{ source_ref } bundle exec rake documentation:generate

        # Copy the docs_config version generated from `docs/VERSIONS` list if there is one.
        [[ -e '#{ config[:output_dir_all_versions] }/docs_config.js' ]] && cp '#{ config[:output_dir_all_versions] }/docs_config.js' '#{ config[:output_dir_all_versions] }/#{ version }/'
      )

      after_version.call(version: version, source_ref: source_ref, result: result) if after_version&.respond_to?(:call)
    end

    # Checkout the initial_git_ref before exiting
    %x(git checkout --quiet #{ initial_git_ref })

    [:ok]
  end

  # Generate a `docs_config.js` file for all versions in `config[:all_versions]`.
  #
  # ### `docs_config.js`
  #
  # This file is used as cheap way to provide the documentation js logic the list of all known documentation versions.
  #
  # A default one is added when generating documentation for a given version, and can then be overwriten by the version generated here.
  #
  # ### `versionNodes`
  #
  # This global JavaScript variable should be providing an array of objects that
  # define all versions of this project which should appear in the project
  # versions dropdown in the documentation sidebar.
  # The versions dropdown allows # for switching between package versions' documentation.
  #
  # Example:
  #
  # ```javascript
  # var versionNodes = [
  #   {
  #     version: "v0.1.0", // version number or name (required)
  #     url: "https://docs.rubykit.org/kit-doc/0.1.0/" // documentation URL (required)
  #   }
  # ]
  # ```
  #
  def self.generate_docs_config(config:, semver_regex: Kit::Doc::Services::Config::SEMVER_REGEX)
    destination_path  = config[:output_dir_all_versions]
    documentation_url = config[:documentation_url]
    versions_list     = (config[:all_versions] || []).map do |version:, **|
      {
        version: version,
        url:     documentation_url.call(version: version),
      }
    end

    file_content = "var versionNodes = #{ JSON.pretty_generate(versions_list) };"
    file_path    = File.join(destination_path, 'docs_config.js')

    FileUtils.mkdir_p(destination_path)
    File.open(file_path, 'w') { |file| file.write(file_content) }

    [:ok, file_path: file_path]
  end

  # Generate a html redirect file.
  #
  #  * `:dst` - Absolute path for the new file.
  #
  #  * `:title` - Html title.
  #
  #  * `:redirect_url` - The url to redirect to.
  #
  def self.generate_html_redirect_file(dst:, title:, redirect_url:)
    file_content = File
      .read(File.expand_path('../../../../assets/redirect.html', __dir__))
      .gsub('$title',        title)
      .gsub('$redirect_url', redirect_url)

    FileUtils.mkdir_p(File.dirname(dst))
    File.open(dst, 'w') { |file| file.write(file_content) }

    [:ok]
  end

end
