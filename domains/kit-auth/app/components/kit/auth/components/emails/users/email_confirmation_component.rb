class Kit::Auth::Components::Emails::Users::EmailConfirmationComponent < Kit::Auth::Components::Emails::EmailComponent

  attr_reader :user_email, :access_token_plaintext_secret

  def initialize(user_email:, access_token_plaintext_secret:, **)
    super

    @user_email                    = user_email.attributes.to_h
    @access_token_plaintext_secret = access_token_plaintext_secret
  end

  def confirmation_link
    Kit::Router::Adapters::Http::Mountpoints.url(
      id:     'web|users|email|confirm',
      params: {
        access_token: access_token_plaintext_secret,
      },
    )
  end

  def liquid_assigns_list
    [:user_email, :confirmation_link]
  end

end
