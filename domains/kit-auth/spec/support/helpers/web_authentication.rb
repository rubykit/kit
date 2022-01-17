module Helpers::WebAuthentication

  # Sign-in the user by going through the real sign in flow.
  def web_real_sign_in(email: 'user@rubykit.com', password: 'Abcd12_xxxxxxxxx')
    visit route_id_to_path(id: 'web|users|sign_in|with_password|new')

    within('form.component_forms_signin-form') do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password

      find('button[type="submit"]').click
    end

    assert_current_path route_id_to_path(id: 'web|users|sign_in|after')

    user
  end

  # Sign-out the user by going through the real sign-out flow.
  def web_real_sign_out(**)
    click_link I18n.t('kit.auth.pages.header.sign_out.action')

    assert_current_path route_id_to_path(id: 'web|users|sign_out|after')
  end

  # Sign-in the user by directly creating an access_token && setting in in the cookies
  def web_sign_in(user:, application: nil)
    application ||= Kit::Auth::Actions::Applications::LoadWeb.call[1][:application]

    _, ctx = Kit::Auth::Actions::AccessTokens::CreateForSignIn.call(user: user, application: application)

    visit route_id_to_path(id: 'specs|cookies|set', params: {
      name:      :access_token,
      value:     ctx[:access_token_plaintext_secret],
      encrypted: true,
    },)
  end

  # Sign-out the user by directly clearing the cookies
  def web_sign_out(**)
    visit route_id_to_path(id: 'specs|cookies|set', params: {
      name:      :access_token,
      value:     nil,
      encrypted: true,
    },)
  end

end
