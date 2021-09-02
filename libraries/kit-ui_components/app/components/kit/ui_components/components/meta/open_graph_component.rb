# Twitter metadata
class Kit::UiComponents::Components::Meta::OpenGraphComponent < Kit::UiComponents::Components::MetaComponent

  def description
    meta[:'og:description']
  end

  def image
    meta[:'og:image']
  end

  def title
    meta[:'og:title']
  end

  def url
    meta[:'og:url']
  end

end
