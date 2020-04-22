include YARD::Templates::Helpers::HtmlHelper

def init
  super

  # Additional CSS
  asset "css/kit_yard.css", file("css/kit_yard.css",true)
end
