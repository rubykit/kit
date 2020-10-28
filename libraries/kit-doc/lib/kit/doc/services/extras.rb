require 'redcarpet'
require 'nokogiri'

# Namsepace for Extras related operations.
module Kit::Doc::Services::Extras

  # Get `extras` list.
  def self.get_extras_list(options:)
    options.files || []

  end

end
