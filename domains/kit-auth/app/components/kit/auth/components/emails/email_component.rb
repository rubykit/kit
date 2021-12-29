class Kit::Auth::Components::Emails::EmailComponent < Kit::Auth::Components::Component

  def liquid_assigns_list
    [:session_user, :brand]
  end

  def liquid_assigns
    liquid_assigns_list.each_with_object({}) { |el, res| res[el] = self.send(el) }
  end

  def render_in(view_context, &block)
    content = super

    BootstrapEmail::Compiler.new(content, type: :string).perform_full_compile.html_safe
  end

  def brand
    {
      logo_url: I18n.t('kit.auth.logo_url'),
    }
  end

end
