module Helpers::WebAuthentication

  def web_sign_in(email: 'user@rubykit.com', password: 'Abcd12_xxxxxxxxx')
    user = create_user(email: email, password: password)
    expect(user).not_to be_nil

    visit route_uid_to_path('web|users|sign_in')

    within('form.component_forms_signin-form') do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end

    click_button 'Sign in'

    assert_current_path route_uid_to_path('web|users|sign_in|after')
  end

  def web_sign_out
    click_link 'Sign out'

    assert_current_path route_uid_to_path('web|users|sign_out|after')
  end

end
