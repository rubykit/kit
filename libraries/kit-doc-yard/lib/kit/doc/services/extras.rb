require 'redcarpet'
require 'nokogiri'

# Namsepace for Extras related operations.
module Kit::Doc::Services::Extras

  def self.get_extras_list(options:)
    list = options.files || []

    list
  end

end
