class Kit::Auth::Components::Emails::Users::SignInLinkComponent < Kit::Auth::Components::Emails::EmailComponent

  attr_reader :user_email, :access_token_plaintext_secret

  def initialize(user_email:, access_token_plaintext_secret:, **)
    super

    @user_email                    = user_email.attributes.to_h
    @access_token_plaintext_secret = access_token_plaintext_secret
  end

  def sign_in_link
    Kit::Router::Adapters::Http::Mountpoints.url(
      id:     'web|authorization_tokens|email|create',
      params: {
        access_token: access_token_plaintext_secret,
      },
    )
  end

  def liquid_assigns_list
    [:user_email, :sign_in_link]
  end

end
