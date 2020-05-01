include YARD::Templates::Helpers::HtmlHelper
include ::Yard::Kit::Templates::Helpers::YardKitPluginHelper

require 'json'

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

# Generate index redirect file.
def handle_main_redirect
  asset('index.html', erb(:index_redirect))
end

# Replace default theme asset handling.
def generate_assets
  handle_static_assets

  create_versions_file
  create_sidebar_file
end

# Copy `assets/dist` to the output path.
def handle_static_assets
  assets_list = [
    [File.join(File.expand_path('../../../..', __dir__), 'assets/dist'), 'assets'],
  ]

  Yard::Kit::Services::Utils.copy_assets({
    basepath: options.serializer.basepath,
    list:     assets_list,
  })
end

# Generate the file containing the list of all known doc versions and their URL
# We do not add a digest because this file will be overwritten from the outside
#  when hosting multiple versions of the documentation.
def create_versions_file
  file_content = erb('docs_config.js')
  asset('docs_config.js', file_content)
end

# Generate the file containing the data to generate the sidebar.
def create_sidebar_file
  file_content = erb('sidebar_items.js')
  file_digest  = Digest::MD5.hexdigest(file_content)[0..9]
  asset("sidebar_items-#{ file_digest }.js", file_content)
end
