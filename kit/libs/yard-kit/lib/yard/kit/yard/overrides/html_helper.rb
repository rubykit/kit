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

        # Comment our parse_codeblocks to avoid having to access `object`
        def htmlify(text, markup = options.markup)
          markup_meth = "html_markup_#{markup}"
          return text unless respond_to?(markup_meth)
          return "" unless text
          return text unless markup
          html = send(markup_meth, text).dup
          if html.respond_to?(:encode)
            html = html.force_encoding(text.encoding) # for libs that mess with encoding
            html = html.encode(:invalid => :replace, :replace => '?')
          end
          html = resolve_links(html)
          #unless [:text, :none, :pre, :ruby].include?(markup)
          #  html = parse_codeblocks(html)
          #end
          html
        end

      end
    end
  end
end