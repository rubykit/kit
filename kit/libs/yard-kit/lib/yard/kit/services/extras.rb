require 'redcarpet'
require 'nokogiri'

module Yard::Kit::Services::Extras

  def self.get_extras_list(options:)
    list = options.files || []

    list
  end

  # Dirty hacks to get a Table of Content hash (based on mardown h1 / h2 / h3 / etc)
  # Only the two first levels are used by the template.
  def self.get_toc(file:)
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

  # Flatten the DOM headers hierarchy recursively
  # @api private
  def self.li_to_hash(node:)
    {
      title:    (node > 'a')&.children&.first&.to_s || '',
      anchor:   (node > 'a')&.attribute('href')&.to_s&.gsub(/^#/, ''),
      sections: ((node > 'ul' > 'li')&.map { |subnode| li_to_hash(node: subnode) }) || [],
    }
  end

end