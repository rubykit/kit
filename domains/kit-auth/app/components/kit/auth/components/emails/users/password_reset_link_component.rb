class Kit::Auth::Components::Emails::Users::PasswordResetLinkComponent < Kit::Auth::Components::Emails::EmailComponent

  attr_reader :user, :access_token

  def initialize(user:, access_token:, **)
    super

    @user         = user.attributes.to_h
    @access_token = access_token
  end

  def reset_link
    Kit::Router::Adapters::Http::Mountpoints.url(
      id:     'web|users|password_reset|edit',
      params: {
        access_token: access_token,
      },
    )
  end

  def liquid_assigns_list
    [:user, :reset_link]
  end

end
