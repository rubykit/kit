class Kit::Auth::Components::Shared::SocialButtonsComponent < Kit::Auth::Components::Component

  def social_services
    [
      {
        name: 'Facebook',
        icon: 'fa-facebook fab-colored',
      },
      {
        name: 'Google',
        icon: 'fa-google   fab-colored fab-colored-gradient',
      },
      {
        name: 'LinkedIn',
        icon: 'fa-linkedin fab-colored',
      },
      {
        name: 'Apple',
        icon: 'fa-apple    fab-colored',
      },
    ]
  end

end
