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

  def self.remove_html_tags(str)
    str.gsub(%r{<\/?[^>]*>}, '')
  end

  def self.remove_html_entities(str)
    str.gsub(%{&([a-zA-Z0-9]+|#[0-9]{1,6}|#x[0-9a-fA-F]{1,6});}, '')
  end

end
