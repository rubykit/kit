# Twitter metadata
class Kit::ViewComponents::Components::Meta::OpenGraphComponent < Kit::ViewComponents::Components::MetaComponent

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
