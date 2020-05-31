include YARD::Templates::Helpers::HtmlHelper # rubocop:disable Style/MixinUsage
include ::Kit::Doc::Yard::TemplatePluginHelper # rubocop:disable Style/MixinUsage

def init
  super
end

# Needed to access the current file object if it exists.
# Used to set `data-type` in the <body>
attr_reader :file
#def file
#  @file
#end

# Use our extended ExtraFile properties
def diskfile
  if @file.respond_to?(:contents_rendered)
    data = @file.contents_rendered
  else
    #super
    @file.attributes[:markup] ||= markup_for_file('', @file.filename)
    data = htmlify(@file.contents, @file.attributes[:markup])
  end

  erb(:extra) { data }
end
