include YARD::Templates::Helpers::HtmlHelper
include ::Yard::Kit::Templates::Helpers::YardKitPluginHelper

def init
  super
end

# Needed to access the current file object if it exists.
# Used to set `data-type` in the <body>
def file
  @file
end
