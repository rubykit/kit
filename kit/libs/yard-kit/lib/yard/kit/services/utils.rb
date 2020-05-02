# Various utilities methods.
module Yard::Kit::Services::Utils

  # Patched version that creates the needed directory (mkdir_p).
  # Sadly, as often with OOP, the original method is an instance one so it does not do us any good as we need to reuse it.
  # @ref https://github.com/lsegal/yard/blob/master/lib/yard/cli/yardoc.rb#L388
  def self.copy_assets(basepath:, list:)
    list.each do |from, to|
      to    = File.join(basepath, to)
      from += '/.' if File.directory?(from)

      #log.debug "Copying asset '#{ from }' to '#{ to }'"

      FileUtils.mkdir_p(to)
      FileUtils.cp_r(from, to)
    end
  end

  # Remove html tags from a string.
  def self.remove_html_tags(str)
    str.gsub(%r{<\/?[^>]*>}, '')
  end

  # Remove html entities from a string.
  def self.remove_html_entities(str)
    str.gsub(%{&([a-zA-Z0-9]+|#[0-9]{1,6}|#x[0-9a-fA-F]{1,6});}, '')
  end

  # In the original code flow, the html rendering is done directly in templates.
  # This allows us to generate the rendered version from anywhere.
  # @ref https://github.com/lsegal/yard/blob/master/templates/default/layout/html/setup.rb#L65
  def self.htmlify(content:, markup: nil)
    markup ||= Yard::Kit::Config.config[:default_yard_markup]

    helper = Struct.new(:options).new()
    helper.extend(::YARD::Templates::Helpers::HtmlHelper)

    helper.htmlify(content, markup)
  end

  # The original implementation has an implicit dependency on `options`.
  # We bypass it by saving the value we need in the Kit config earlier.
  # @ref https://github.com/lsegal/yard/blob/master/lib/yard/templates/helpers/markup_helper.rb#L132
  def self.markup_for_file(filename:, content: '')
    return $1.to_sym if content && content =~ ::YARD::Templates::Helpers::MarkupHelper::MARKUP_FILE_SHEBANG # Shebang support

    ext = (File.extname(filename)[1..-1] || '').downcase
    ::YARD::Templates::Helpers::MarkupHelper::MARKUP_EXTENSIONS.each do |type, exts|
      return type if exts.include?(ext)
    end

    Yard::Kit::Config.config[:default_yard_markup]
  end

  # If a class if module is defined in several files, removes the one that are nested, as it is probably used as a namespace in that case.
  def self.cleanup_files(list:)
    list.reject do |cr_el_path, _cr_el_line|
      cr_el_path = cr_el_path[0..-4] if cr_el_path.end_with?('.rb')

      status = false
      list.each do |el_path, _el_line|
        el_path = el_path[0..-4] if el_path.end_with?('.rb')

        if cr_el_path.start_with?(el_path) && el_path.size < cr_el_path.size
          status = true
          break
        end
      end
      status
    end
  end

end
