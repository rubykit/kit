include YARD::Templates::Helpers::HtmlHelper
include ::Yard::Kit::Templates::Helpers::YardKitPluginHelper

require 'json'
require 'nokogiri'

# @todo Rewrite with Kit::Organizer?
# @ref https://github.com/lsegal/yard/blob/master/templates/default/fulldoc/html/setup.rb#L4
def init
  options.objects = objects = run_verifier(options.objects)
  return serialize_onefile if options.onefile

  # Handle README before we generate anything referencing it.
  handle_readme
  generate_assets

  serialize('_index.html')
  rename_api_reference

  handle_main_redirect

  options.files.each_with_index do |file, _i|
    serialize_file(file, file.title)
  end

  #options.delete(:objects)
  #options.delete(:files)

  objects.each do |object|
    serialize(object)
  rescue StandardError => e
    path = options.serializer.serialized_path(object)
    log.error "Exception occurred while generating '#{path}'"
    log.backtrace(e)
  end

end

# Yard treats README differently and doesn't land itself to being patched.
# @ref https://github.com/lsegal/yard/blob/master/lib/yard/cli/yardoc.rb#L297
def handle_readme
  # We double check if the README was in the original file_list, otherwise we remove it
  first_file = options.files.first

  return if first_file&.name != 'README'

  kit_files_extra = config[:files_extra] || []
  if !kit_files_extra.find { |path| path.end_with?(first_file.filename) }
    options.files.shift
  end
end

# The API reference is generated as _index.html, fix this.
def rename_api_reference
  from = File.join(config[:output_dir], '_index.html')
  to   = File.join(config[:output_dir], 'api_reference.html')

  FileUtils.mv(from, to, force: true)
end

def handle_main_redirect
  asset('index.html', erb(:index_redirect))
end

# Replace default theme asset handling.
def generate_assets
  handle_static_assets
  create_versions_file
  create_sidebar_file
end

# Get the list of files
def get_extras_list
  list ||= options.files || []

  list
end

# Get the list of modules / classes
def get_modules_list
  # TODO: check if we should use this?
  # list = options.objects || []

  list = Registry.all(:class, :module)
  list = run_verifier(list)

  list
end

# Copy `assets/dist` to the output path
def handle_static_assets
  assets_list = [
    [File.join(File.expand_path('../../../..', __dir__), 'assets/dist'), 'assets'],
  ]

  copy_assets(assets_list)
end

# Generate the file containing the list of all known doc versions and their URL
def create_versions_file
  asset('docs_config.js', erb('docs_config.js'))
end

# Generate the file containing the data to generate the sidebar
def create_sidebar_file
  asset('sidebar_items.js', erb('sidebar_items.js'))
end

# Patched version that creates the needed directory (mkdir_p).
# Sadly, as often with OOP, the original method is an instance one so it does not do us any good as we need to reuse it.
# @ref https://github.com/lsegal/yard/blob/master/lib/yard/cli/yardoc.rb#L388
def copy_assets(list)
  return unless options.serializer

  outpath = options.serializer.basepath
  list.each do |from, to|
    to    = File.join(outpath, to)
    from += '/.' if File.directory?(from)

    log.debug "Copying asset '#{ from }' to '#{ to }'"

    FileUtils.mkdir_p(to)
    FileUtils.cp_r(from, to)
  end
end

# Flatten the DOM headers hierarchy recursively
def li_to_hash(node:)
  {
    title:    (node > 'a')&.children&.first&.to_s || '',
    anchor:   (node > 'a')&.attribute('href')&.to_s&.gsub(/^#/, ''),
    sections: ((node > 'ul' > 'li')&.map { |subnode| li_to_hash(node: subnode) }) || [],
  }
end

# Dirty hacks to get a Table of Content hash (based on mardown h1 / h2 / h3 / etc)
# Only the two first levels are used by the template.
def get_toc(file:)
  begin
    renderer  = Redcarpet::Render::HTML_TOC.new()
    markdown  = Redcarpet::Markdown.new(renderer)
    rendered  = markdown.render(file.contents).delete("\n")
    local_dom = Nokogiri::HTML.parse(rendered)
    result    = local_dom.css(':not(li) > ul > li').map { |node| li_to_hash(node: node) }
  rescue StandardError
    result = []
  end

  result
end

# Generate the group container needed in `sidebar_items`.
# This maintain the group order defined in the initial config.
# If no group is specified, we use the empty group (first to be displayed).
def get_groups_list(groups:)
  result = {}

  if groups.first[0] != ''
    result[''] = []
  end

  groups.each do |name, _|
    result[name] = []
  end

  result
end

# Assign a group to a module / extra based on the initial config.
# A module / extra can be in multiple groups.
def match_groups(groups:, value:)
  result = []

  groups.each do |group_name, regex_list|
    regex_list = [regex_list] if !regex_list.is_a?(::Array)

    regex_list.each do |regex|
      next if !regex&.is_a?(::Regexp)

      if regex.match?(value)
        result << group_name
      end
    end
  end

  result.size > 0 ? result : ['']
end
