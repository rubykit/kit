# Documentation config.
module Kit::Doc::Services::Config

  # The Service currently acts as a singleton to hold the current config for Yard.
  # This is obviously not thread safe, but this is only used for tooling, so it should not matter.
  class << self

    attr_accessor :config

  end

  # TODO: add doc. There is some non-bvious behaviour going on here.
  def self.get_default_config(**opts)
    config = {
      output_dir_base:   'docs/dist',
      extra_section:     'Guides',
      main:              'overview',
      main_redirect_url: 'index.html',
    }

    config.merge!(opts)

    if config[:gemspec_name]
      gemspec_data = load_gemspec_data({
        gemspec_name: config[:gemspec_name],
      })

      {
        project:           gemspec_data.name,
        version:           gemspec_data.version,
        source_url:        gemspec_data.metadata['source_code_uri'],
        documentation_url: gemspec_data.metadata['documentation_uri'],
        authors:           [gemspec_data.author],
      }.each do |k, v|
        config[k] = v if !config[k]
      end
    end

=begin
    if config[:git_project_path]
      # source_ref && repo_url
      get_git_version({
        git_project_path: config[:git_project_path],
        version:          config[:version],
        source_url:       config[:source_url],
      }).each do |k, v|
        config[k] = v if !config[k]
      end
    end
=end

=begin
    if config[:source_ref] == 'edge'
      config[:documentation_url] = config[:documentation_url].gsub("v#{ config[:version] }", 'edge')
      config[:version]           = 'edge'
    end
=end

    if !config[:output_dir]
      config[:output_dir] = "#{ config[:output_dir_base] }/#{ config[:version] }"
    end

    config
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

end
