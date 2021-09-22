class Kit::Auth::Components::Emails::Users::SignInLinkComponent < Kit::Auth::Components::Emails::EmailComponent

  attr_reader :user, :access_token

  def initialize(user:, access_token:, **)
    super

    @user         = user.attributes.to_h
    @access_token = access_token
  end

  def sign_in_link
    Kit::Router::Adapters::Http::Mountpoints.url(
      id:     'web|authorization_tokens|email|create',
      params: {
        access_token: access_token,
      },
    )
  end

  def liquid_assigns_list
    [:user, :sign_in_link]
  end

end
