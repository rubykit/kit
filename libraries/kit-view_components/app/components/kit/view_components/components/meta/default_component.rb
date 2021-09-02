# Default
class Kit::ViewComponents::Components::Meta::DefaultComponent < Kit::ViewComponents::Components::MetaComponent

  def locale
    I18n.locale
  end

end
