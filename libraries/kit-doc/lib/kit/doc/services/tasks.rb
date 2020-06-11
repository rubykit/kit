require 'rubygems'
require 'fileutils'
require 'git'

# Utilities methods to create documentation rake tasks for yard
module Kit::Doc::Services::Tasks

  # Create yard rake task with Kit::Doc::Yard setup
  def self.create_rake_task_documentation_generate!(config:, task_name: 'documentation:generate', clean_output_dir: false)
    ::YARD::Rake::YardocTask.new do |t|
      t.name    = task_name

      t.before  = -> do
        Kit::Doc::Services::Config.config = config

        if clean_output_dir && !config[:output_dir].empty?
          FileUtils.rm_rf(Dir[config[:output_dir] + '/*'])
        end
      end

      t.files   = (config[:files_modules] + ['-'] + config[:files_extras]).flatten

      t.options = [
        '--output-dir',      config[:output_dir],
        '--plugin',          'kit-doc', 'kit-doc-contracts', # Redundant with `.yardopts`?
        '--markup-provider', 'redcarpet',
        '--markup',          'markdown',
      ]
    end
  end

  def self.create_rake_task_documentation_generate_all_versions!(config:, task_name: 'documentation:generate:all_versions')
    ::Rake::Task.define_task task_name do
      puts "Generating documentation for `#{ config[:project] }`"
      if !config[:versions] || config[:versions].size == 0
        puts '  No versions provided.'
        exit
      end

      puts "  Versions: #{ config[:versions].map { |el| el[:version] }.join(' ') }"

      # Add `docs_config.js`
      generate_docs_config(config: config)

      # Generate documentation for every given version.
      generate_documentation_all_versions(
        config:         config,
        before_version: ->(version:, source_ref:) { puts "  Generating version `#{ version }` (source_ref: `#{ source_ref }`)" },
        after_version:  ->(result:, **)           { puts result.gsub("\n", "\n    ") },
      )

      # Add top level `index.html` redirect file. Use the first value of config[:versions] as the default.
      generate_html_redirect_file(
        dst:          File.join(config[:output_dir_base], 'index.html'),
        title:        "#{ config[:project] } documentation",
        redirect_url: "#{ config[:versions][0][:version] }/index.html",
      )
    end
  end

  # Run `documentation:generate` after checking out the git reference.
  def self.generate_documentation_all_versions(config:, before_version: nil, after_version: nil)
    # Save current current git reference
    initial_git_ref = Git.open(config[:git_project_path]).current_branch

    config[:versions].each do |version:, source_ref:|
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
        KIT_DOC_OUTPUT_DIR_BASE=#{ config[:output_dir_base] } KIT_DOC_VERSION=#{ version } KIT_DOC_SOURCE_REF=#{ source_ref } bundle exec rake documentation:generate

        # Copy the docs_config version generated from `docs/VERSIONS` list if there is one.
        [[ -e '#{ config[:output_dir_base] }/docs_config.js' ]] && cp '#{ config[:output_dir_base] }/docs_config.js' '#{ config[:output_dir_base] }/#{ version }/'
      )

      after_version.call(version: version, source_ref: source_ref, result: result) if after_version&.respond_to?(:call)
    end

    # Checkout the initial_git_ref before exiting
    %x(git checkout --quiet #{ initial_git_ref })

    [:ok]
  end

  # Generate `docs_config.js` file for all versions in config[:versions]
  def self.generate_docs_config(config:)
    destination_path  = config[:output_dir_base]
    gemspec_data      = Kit::Doc::Services::Config.load_gemspec_data(gemspec_name: config[:gemspec_name])
    documentation_uri = gemspec_data.metadata['documentation_uri']
    versions_list     = (config[:versions] || []).map do |version:, **|
      {
        version: version,
        url:     documentation_uri.gsub("v#{ gemspec_data.version }", version),
      }
    end

    file_content = "var versionNodes = #{ JSON.pretty_generate(versions_list) };"
    file_path    = File.join(destination_path, 'docs_config.js')
    File.open(file_path, 'w') { |file| file.write(file_content) }

    [:ok, file_path: file_path]
  end

  # Generate html redirect file.
  def self.generate_html_redirect_file(dst:, title:, redirect_url:)
    file_content = File
      .read(File.expand_path('../../../../assets/redirect.html', __dir__))
      .gsub('$title',        title)
      .gsub('$redirect_url', redirect_url)

    FileUtils.mkdir_p(File.dirname(dst))
    File.open(dst, 'w') { |file| file.write(file_content) }

    [:ok]
  end

  # Expand paths
  def self.resolve_files(hash:)
    hash
      .map do |lib_path, data|
        (data[:include] || []).map { |path| Dir[File.join(lib_path, path)] }
      end
      .flatten
  end

  # Display helper: return a helper that compute the needed css padding based on nesting, ignoring `hide`.
  def self.display_helper_css_padding(hide: nil)
    ->(name) do
      #size = name.gsub(text, '').gsub(%r{^::}, '').scan('::').size
      if hide
        name = name.gsub(hide, '')
      end
      size = name.scan('::').size
      ["#{ (size > 0) ? "sidebar-pl-#{ size }" : '' }"]
    end
  end

  # Display helper: return a helper that return last object name
  def self.display_helper_last_name
    ->(name) { name.split('::')[-1] }
  end

end
