# Meta elements + title
class Kit::ViewComponents::Components::Meta::ContentComponent < Kit::ViewComponents::Components::MetaComponent

  def title
    meta[:title]
  end

  def application_name
    meta[:application_name]
  end

  def description
    meta[:description]
  end

  def keywords
    (meta[:keywords] || [])
      .flatten
      .reject(&:blank?)
      .join(', ')
  end

end
