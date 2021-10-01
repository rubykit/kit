module Helpers::WebAuthentication

  def web_sign_in(email: 'user@rubykit.com', password: 'Abcd12_xxxxxxxxx')
    visit route_id_to_path(id: 'web|users|sign_in')

    within('form.component_forms_signin-form') do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end

    click_button 'Sign in'

    assert_current_path route_id_to_path(id: 'web|users|sign_in|after')

    user
  end

  def web_sign_out
    click_link 'Sign out'

    assert_current_path route_id_to_path(id: 'web|users|sign_out|after')
  end

end
