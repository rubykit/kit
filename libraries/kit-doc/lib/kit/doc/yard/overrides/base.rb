class ::YARD::CodeObjects::Base # rubocop:disable Style/Documentation

  # In the original code flow, the html rendering is done directly in templates.
  #
  # This addition allows us to access the rendered version anywhere, and to cache it.
  #
  # Note: this is an addition, not present in the original class.
  #
  def docstring_rendered(locale = nil)
    locale ||= ::YARD::I18n::Locale.default
    if locale.is_a?(String)
      locale_name = locale
    elsif locale
      locale_name = locale.name
    else
      locale_name = nil
    end

    @docstrings_rendered ||= {}
    @docstrings_rendered[locale_name] ||= Kit::Doc::Services::Utils.htmlify({
      content:            docstring,
      markdown_variables: Kit::Doc::Services::Config.config[:markdown_variables],
      yard_code_object:   self,
    })
  end

end
