def init
  super
end

def stylesheets
  # Load the existing stylesheets while appending the custom one
  super + %w(css/kit_yard.css)
end
