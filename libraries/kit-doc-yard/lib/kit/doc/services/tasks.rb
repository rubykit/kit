require 'rubygems'
require 'git'

# Utilities methods to create documentation rake tasks for yard
module Kit::Doc::Services::Tasks

  # Create yard rake task with Kit::Doc::Yard setup
  def self.create_rake_documentation_task!(config:, task_name: 'documentation:yardoc:all', clean_output_dir: false)
    YARD::Rake::YardocTask.new do |t|
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
        '--plugin',          'kit-doc-yard', 'kit-doc-yard-contracts', # Redundant with `.yardopts`?
        '--markup-provider', 'redcarpet',
        '--markup',          'markdown',
      ]
    end
  end

  # Check that the version is a Git tag, otherwise for now, assume this is edge.
  def self.get_git_version(git_project_path:, version:, source_url:)
    g        = Git.open(git_project_path)
    tag_name = "v#{ version }"

    if g.tags.include?(tag_name)
      source_ref       = tag_name
      code_version_ref = tag_name
    else
      source_ref       = 'edge'
      code_version_ref = g.log.first.objectish
    end

    {
      source_ref: source_ref,
      repo_url:   "#{ source_url }/blob/#{ code_version_ref }",
    }
  end

  def self.get_default_config(**opts)
    config = {
      output_dir_base:   'docs/dist',
      extra_section:     'Guides',
      assets:            'guides/assets',
      main:              'overview',
      main_redirect_url: 'index.html',
    }

    config.merge!(opts)

    if config[:gemspec_name]
      gemspec_data = load_gemspec_data({
        gemspec_name: config[:gemspec_name],
      })

      config.merge!({
        project:           gemspec_data.name,
        version:           gemspec_data.version,
        source_url:        gemspec_data.metadata['source_code_base_uri'],
        documentation_url: gemspec_data.metadata['documentation_uri'],
        authors:           [gemspec_data.author],
      })
    end

    if config[:git_project_path]
      config.merge!(get_documentation_version({
        git_project_path: config[:git_project_path],
        version:          config[:version],
        source_url:       config[:source_url],
      }))
    end

    if config[:source_ref] == 'edge'
      config[:documentation_url] = config[:documentation_url].gsub("v#{ config[:version] }", 'edge')
      config[:version]           = 'edge'
    end

    if !config[:output_dir]
      config[:output_dir] = "#{ config[:output_dir_base] }/#{ config[:source_ref] }"
    end

    config
  end

  # Load gemspec file
  def self.load_gemspec_data(gemspec_name:)
    gemspec_data = Gem::Specification.find_by_name(gemspec_name)

=begin
    extension = '.gemspec'

    if !gemspec_path.end_with?(extension)
      raise "Kit::Doc - Refused to eval `#{ gemspec_path }`, it does not end in `#{ extension }`"
    end

    gemspec_data = eval(File.read(gemspec_path), binding, gemspec_path)
=end

    gemspec_data
  end

  # Expand paths
  def self.resolve_files(hash:)
    hash
      .map do |lib_path, data|
        (data[:include] || []).map { |path| Dir[File.join(lib_path, path)] }
      end
      .flatten
  end

end
