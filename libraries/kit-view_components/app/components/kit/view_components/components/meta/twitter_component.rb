# Twitter metadata
class Kit::ViewComponents::Components::Meta::TwitterComponent < Kit::ViewComponents::Components::MetaComponent

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
