include YARD::Templates::Helpers::HtmlHelper # rubocop:disable Style/MixinUsage
include ::Kit::Doc::Yard::TemplatePluginHelper # rubocop:disable Style/MixinUsage

def init # rubocop:disable Lint/UselessMethodDefinition
  super
end

# Needed to access the current file object if it exists.
# Used to set `data-type` in the <body>
attr_reader :file

# Use our extended ExtraFile properties
def diskfile
  if @file.respond_to?(:contents_rendered)
    data = @file.contents_rendered
  else
    #super
    @file.attributes[:markup] ||= markup_for_file('', @file.filename)

    data = Kit::Doc::Services::Utils.htmlify({
      content:            @file.contents,
      markdown_variables: Kit::Doc::Services::Config.config[:markdown_variables],
      markup:             @file.attributes[:markup],
    })
  end

  erb(:extra) { data }
end
