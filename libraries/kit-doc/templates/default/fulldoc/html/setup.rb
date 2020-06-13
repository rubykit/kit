include YARD::Templates::Helpers::HtmlHelper # rubocop:disable Style/MixinUsage
include ::Kit::Doc::Yard::TemplatePluginHelper # rubocop:disable Style/MixinUsage

require 'json'

# Entry point for the Kit::Doc template.
#
# ### References:
# - https://github.com/lsegal/yard/blob/master/templates/default/fulldoc/html/setup.rb#L4
#
def init
  # Ugly trick to be able to reuse some Yard code out of order.
  Kit::Doc::Services::Config.config[:default_yard_markup] = options.markup

  if options.title.start_with?('Documentation by YARD')
    options.title = nil
  end

  options.objects = run_verifier(options.objects)
  return serialize_onefile if options.onefile

  # Order dependant: handles README before we generate anything referencing it (ex: sidebar_items)
  handle_readme

  # Order dependant: some files names contain a digest, they need to be generated / copied first so that other files may reference them.
  handle_static_assets
  generate_js_versions_file
  generate_js_sidebar_file

  # Order independant from here.
  generate_api_reference
  generate_main_redirect

  generate_extras_files
  generate_objects_files

  generate_js_search_file
  generate_html_search_file
end

# Yard treats README differently and doesn't land itself to being patched.
# Caution advised as there is some weird non standard behaviour.
# @ref https://github.com/lsegal/yard/blob/master/lib/yard/cli/yardoc.rb#L297
def handle_readme
  # We double check if the README was in the original file_list, otherwise we remove it
  first_file = options.files.first

  return if first_file&.name != 'README'

  kit_files_extra = config[:files_extra] || []
  if !kit_files_extra.find { |path| path.end_with?(first_file.filename) } # rubocop:disable Style/GuardClause
    options.files.shift
  end
end

# Copy `assets/dist` to the output path.
def handle_static_assets
  assets_list = [
    [File.join(File.expand_path('../../../..', __dir__), 'assets/dist'), 'assets'],
  ]

  config = Kit::Doc::Services::Config.config
  config[:assets]&.each do |el|
    assets_list << el
  end

  Kit::Doc::Services::Utils.copy_assets({
    basepath: options.serializer.basepath,
    list:     assets_list,
  })
end

# Generate the file containing the list of all known doc versions and their URL.
# No digest is added as this file will be overwritten when hosting multiple versions of the documentation.
def generate_js_versions_file
  file_content = erb('docs_config.js')
  asset('docs_config.js', file_content)
end

# Generate the file containing the data for the sidebar.
def generate_js_sidebar_file
  file_content = erb('sidebar_items.js')
  file_digest  = Digest::MD5.hexdigest(file_content)[0..9]
  asset("sidebar_items-#{ file_digest }.js", file_content)
end

# Generates API Reference file.
# Caution advised as there is some weird non standard behaviour.
def generate_api_reference
  initial_title = options.title

  options.title = 'API Reference'
  # '_index.html' is a "magic" value.
  serialize('_index.html')

  # Rename the generated file.
  from = File.join(config[:output_dir_current_version], '_index.html')
  to   = File.join(config[:output_dir_current_version], 'api_reference.html')
  FileUtils.mv(from, to, force: true)

  options.title = initial_title
end

# Generate index redirect file.
def generate_main_redirect
  asset('index.html', erb(:index_redirect))
end

# Generate `extras` files
def generate_extras_files
  initial_title = options.title
  options.files.each_with_index do |file, _|
    options.title = (file.contents_toc&.dig(0, :title) || file.title)
    serialize_file(file)
  end
  options.title = initial_title
end

# Generate `objects` files
def generate_objects_files
  options.objects = run_verifier(options.objects)

  options.objects.each do |object|
    serialize(object)
  rescue StandardError => e
    path = options.serializer.serialized_path(object)
    log.error "Exception occurred while generating '#{ path }'"
    log.backtrace(e)
  end
end

# Generate the file that dumps all content to allow full text search.
def generate_js_search_file
  file_content = erb('search_items.js')
  file_digest  = Digest::MD5.hexdigest(file_content)[0..9]

  # Allows to bust the search sessionStorage cache when the assets change
  @search_items_digest = file_digest

  asset("search_items-#{ file_digest }.js", file_content)
end

# Generate the file makes use of the js search file.
def generate_html_search_file
  file_content = erb('search')

  template_options = options.merge({
    object:         Registry.root,
    contents:       file_content,
    body_data_type: 'search',
    title:          'Search',
  })

  Templates::Engine.with_serializer('search.html', options.serializer) do
    T('layout').run(template_options)
  end
end
