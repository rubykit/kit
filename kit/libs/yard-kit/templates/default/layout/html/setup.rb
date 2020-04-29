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

# Get the list of modules / classes
def get_modules_list
  # TODO: check if we should use this?
  # list = options.objects || []

  list = Registry.all(:class, :module)
  list = run_verifier(list)

  list
end

# Used for the API Reference
def docstring_full(obj)
  docstring = (obj.tags(:overload).size == 1 && obj.docstring.empty?) ? obj.tag(:overload).docstring : obj.docstring

  if docstring.summary.empty? && obj.tags(:return).size == 1 && obj.tag(:return).text
    docstring = Docstring.new(obj.tag(:return).text.gsub(/\A([a-z])/, &:upcase).strip)
  end

  docstring
end

# Used for the API Reference
def docstring_summary(obj)
  docstring_full(obj).summary
end
