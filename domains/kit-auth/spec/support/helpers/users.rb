module Helpers::Users

  # Create a user with the correct Events.
  #
  # Note: this is the only difference with using factory bot directly.
  def create_user(email: 'user@rubykit.com', password: 'Abcd12_xxxxxxxxx')
    _status, ctx = Kit::Auth::Actions::Users::CreateWithPassword.call(
      email:    email,
      password: password,
      #password_confirmation: password,
    )
    ctx[:user]
  end

  # Create a new access_token for `:user` & set it in the cookies of the Capybara session.
  #
  # ⚠️ This will create a new `UserSecret` to get the plaintext secret.
  def sign_in_user_for_feature(user:, application: nil)
    application ||= Kit::Auth::Actions::Applications::LoadWeb.call.dig(1, :application)
    secret       = Kit::Auth::Actions::AccessTokens::CreateForSignIn.call(user: user, application: application).dig(1, :access_token_plaintext_secret)

    visit route_id_to_path(id: 'specs|cookies|set', params: {
      name:      :access_token,
      value:     secret,
      encrypted: true,
    },)
  end

end
