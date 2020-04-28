include YARD::Templates::Helpers::HtmlHelper
include ::Yard::Kit::Templates::Helpers::YardKitPluginHelper

require 'json'
require 'nokogiri'

def init
  # Somehow options.files gets cleared in the flow, so we need to catch a ref here.
  @extras_list = options.files

  super
end

# Replace default theme asset handling.
def generate_assets
  handle_static_assets
  create_versions_file
  create_sidebar_file
end

def get_extras_list
  list = @extras_list || []

  list
end

def get_modules_list
  # TODO: check if we should use this?
  # list = options.objects || []

  list = Registry.all(:class, :module)
  list = run_verifier(list)

  list
end

def handle_static_assets
  assets_list = [
    [File.join(File.expand_path('../../../..', __dir__), 'assets/dist'), 'assets'],
  ]

  copy_assets(assets_list)
end

def create_versions_file
  asset('docs_config.js', erb('docs_config.js'))
end

def create_sidebar_file
  asset('sidebar_items.js', erb('sidebar_items.js'))
end

# @see yard/lib/yard/cli/yardoc.rb
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

def get_groups_list(groups:)
  result = {}

  # The empty group is the first one to be displayed.
  if groups.first[0] != ''
    result[''] = []
  end

  groups.each do |name, _|
    result[name] = []
  end

  result
end

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
