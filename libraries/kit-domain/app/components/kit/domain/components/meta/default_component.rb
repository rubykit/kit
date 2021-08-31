# Default
class Kit::Domain::Components::Meta::DefaultComponent < Kit::Domain::Components::MetaComponent

  def locale
    I18n.locale
  end

end
