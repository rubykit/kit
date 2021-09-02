# Twitter metadata
class Kit::UiComponents::Components::Meta::TwitterComponent < Kit::UiComponents::Components::MetaComponent

  def description
    meta[:'twitter:description']
  end

  def image
    meta[:'twitter:image']
  end

  def site
    meta[:'twitter:site']
  end

  def title
    meta[:'twitter:title']
  end

end
