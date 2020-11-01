module Helpers::Users

  def create_user(email: 'user@rubykit.com', password: 'Abcd12_xxxxxxxxx')
    _status, ctx = Kit::Auth::Actions::Users::CreateWithPassword.call(
      email: email, password: password, password_confirmation: password,
    )
    ctx[:user]
  end

end
