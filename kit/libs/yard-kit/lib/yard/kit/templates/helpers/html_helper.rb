module YARD
  module Templates
    module Helpers
      module HtmlHelper

        # Add `:with_toc_data` to RedCarpet
        def html_markup_markdown(text)
          provider = markup_class(:markdown)
          if provider.to_s == 'RDiscount'
            provider.new(text, :autolink).to_html
          elsif provider.to_s == 'RedcarpetCompat'
            provider.new(text, :no_intraemphasis, :gh_blockcode, :fenced_code, :autolink, :tables, :lax_spacing, :with_toc_data).to_html
          else
            provider.new(text).to_html
          end
        end

      end
    end
  end
end
