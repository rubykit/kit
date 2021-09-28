class Kit::Auth::Components::Emails::Users::PasswordResetLinkComponent < Kit::Auth::Components::Emails::EmailComponent

  attr_reader :user_email, :access_token_plaintext_secret

  def initialize(user_email:, access_token_plaintext_secret:, **)
    super

    @user_email                    = user_email.attributes.to_h
    @access_token_plaintext_secret = access_token_plaintext_secret
  end

  def reset_link
    Kit::Router::Adapters::Http::Mountpoints.url(
      id:     'web|users|password_reset|edit',
      params: {
        access_token: access_token_plaintext_secret,
      },
    )
  end

  def liquid_assigns_list
    [:user_email, :reset_link]
  end

end
