# Default
class Kit::UiComponents::Components::Meta::DefaultComponent < Kit::UiComponents::Components::MetaComponent

  def locale
    I18n.locale
  end

end
