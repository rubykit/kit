# Twitter metadata
class Kit::Domain::Components::Meta::TwitterComponent < Kit::Domain::Components::MetaComponent

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
