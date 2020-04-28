include YARD::Templates::Helpers::HtmlHelper
include ::Yard::Kit::Templates::Helpers::YardKitPluginHelper

def init
  super
end

def file
  @file
end

def docstring_full(obj)
  docstring = (obj.tags(:overload).size == 1 && obj.docstring.empty?) ? obj.tag(:overload).docstring : obj.docstring

  if docstring.summary.empty? && obj.tags(:return).size == 1 && obj.tag(:return).text
    docstring = Docstring.new(obj.tag(:return).text.gsub(/\A([a-z])/, &:upcase).strip)
  end

  docstring
end

def docstring_summary(obj)
  docstring_full(obj).summary
end

def get_modules_list
  # TODO: check if we should use this?
  # list = options.objects || []

  list = Registry.all(:class, :module)
  list = run_verifier(list)

  list
end
