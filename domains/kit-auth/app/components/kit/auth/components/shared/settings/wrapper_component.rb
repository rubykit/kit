class Kit::Auth::Components::Shared::Settings::WrapperComponent < Kit::Auth::Components::Component

  def sections
    [
      {
        name:     'Security & Login',
        icon:     'fas fa-shield-alt',
        route_id: 'web|settings|sessions|index',
      },
      {
        name:     'Social Services',
        icon:     'fas fa-cubes',
        route_id: 'web|settings|oauth|index',
      },
    ]
  end

end
