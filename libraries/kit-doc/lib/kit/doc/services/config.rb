require 'pathname'

# Documentation config.
module Kit::Doc::Services::Config

  # The Service currently acts as a singleton to hold the current config for Yard.
  # This is obviously not thread safe, but this is only used for tooling, so it should not matter.
  class << self

    attr_accessor :config

  end

  # Reference: https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
  # Note that this is a more permissive version to match semver inside strings.
  SEMVER_REGEX = %r{(v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?)}

  # TODO: add doc. There is some non-bvious behaviour going on here.
  def self.get_default_config(**opts)
    defaults = {
      mode:                    :local,
      version:                 'dev',
      versions:                [],
      output_dir_all_versions: 'docs/dist',
      extra_section:           'Guides',
      main:                    'overview',
      main_redirect_url:       'index.html',
    }

    config = opts.dup
    defaults.each { |k, v| config[k] = v if !config[k] }
    config[:mode] = config[:mode].to_sym

    if !config[:source_ref]
      config[:source_ref] = Kit::Doc::Services::Config.get_git_source_ref(git_project_path: config[:git_project_path])[1][:source_ref]
    end

    if config[:versions].is_a?(String)
      config[:versions] = Kit::Doc::Services::Config.load_versions_file(path: config[:versions])[1][:versions]
    end

    if config[:gemspec_name]
      gemspec_data       = load_gemspec_data(gemspec_name: config[:gemspec_name])
      gemspec_attributes = {
        project: gemspec_data.name,
        authors: [gemspec_data.author],
      }

      if config[:mode] != :local
        gemspec_attributes.merge!({
          version:           gemspec_data.version,
          source_url:        gemspec_data.metadata['source_code_uri'],
          documentation_url: ->(version:) { gemspec_data.metadata['documentation_uri'].gsub(SEMVER_REGEX, version) },
        })
      end

      gemspec_attributes.each { |k, v| config[k] = v if !config[k] }
    end

    if !Pathname.new(config[:output_dir_all_versions]).absolute?
      config[:output_dir_all_versions] = "#{ config[:project_path] }/#{ config[:output_dir_all_versions] }"
    end

    if !config[:output_dir_current_version]
      config[:output_dir_current_version] = "#{ config[:output_dir_all_versions] }/#{ config[:version] }"
    end

    if !Pathname.new(config[:output_dir_current_version]).absolute?
      config[:output_dir_current_version] = "#{ config[:project_path] }/#{ config[:output_dir_current_version] }"
    end

    if config[:documentation_url].is_a?(String)
      documentation_url_saved_value = config[:documentation_url]
      config[:documentation_url] = ->(version:) { documentation_url_saved_value }
    elsif config[:mode] == :local
      config[:documentation_url] = ->(version:) { "file://#{ config[:output_dir_all_versions] }/#{ version }/index.html" }
    elsif !config[:documentation_url].respond_to?(:call)
      config[:documentation_url] = ->(version:) { '' }
    end

    if !config[:source_url].respond_to?(:call)
      source_url_saved_value = config[:source_url]
      config[:source_url]    = ->(path:, line:) do
        Kit::Doc::Services::Config.generate_source_url(
          source_url: source_url_saved_value,
          source_ref: config[:source_ref],
          path:       path,
          line:       line,
        )
      end
    end

    config[:version_display] = "#{ (config[:version] =~ %r{^[0-9]}) ? 'v' : '' }#{ config[:version] }"

    config
  end

  # For a given
  def self.generate_source_url(source_url:, source_ref:, path:, line:)
    separator = 'github.com/'

    if source_url.include?(separator)
      url_split     = source_url.chomp('/').split(separator)
      path_split    = url_split[1].split('/')

      path_split[2] = 'blob'
      path_split[3] = source_ref
      path_split << "#{ path }#L#{ line }"
      url_split[1] = path_split.join('/')

      url_split.join(separator)
    else
      ''
    end
  end

  # Load gemspec file
  def self.load_gemspec_data(gemspec_name:)
    gemspec_data = Gem::Specification.find_by_name(gemspec_name)

    gemspec_data
  end

  # Parse a VERSIONS file.
  #
  # Expected format per line:
  # `version[:source_ref]`
  # `version` is the name you give to a version.
  # `source_ref` can be a commit, branch, tag. It defaults to `version` if not specified.
  def self.load_versions_file(path:)
    content  = File.readlines(path)
    versions = content.filter_map do |line|
      line = line.presence
      next if !line

      line = line.strip.split(':')

      { version: line[0], source_ref: line[1] || line[0] }
    end

    [:ok, versions: versions]
  end

  # Attempt to guess the most accurate git source_ref.
  # Currently: first branch, then last commit.
  def self.get_git_source_ref(git_project_path:)
    git_data   = Git.open(git_project_path)
    source_ref = git_data.current_branch

    if source_ref.include?('detached')
      source_ref = git_data.log.first.objectish
    end

    [:ok, source_ref: source_ref]
  end

end
