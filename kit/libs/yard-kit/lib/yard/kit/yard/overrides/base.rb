class ::YARD::CodeObjects::Base

  # In the original code flow, the html rendering is done directly in templates.
  # This allows us to access the rendered version anywhere, and to cache it.
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
    @docstrings_rendered[locale_name] ||= Yard::Kit::Services::Utils.htmlify({
      content: docstring,
    })
  end

end