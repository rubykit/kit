class Kit::Auth::Components::Shared::EmailServicesComponent < Kit::Auth::Components::Component

  def services
    [
      {
        name: 'Gmail',
        icon: 'fab-extra-gmail',
        link: 'https://mail.google.com/mail/u/0/',
      },
      {
        name: 'Outlook',
        icon: 'fab-extra-outlook',
        link: 'https://outlook.live.com/mail/0/inbox',
      },
    ]
  end

end
