module Kit::Auth::Actions::Users::VerifyPassword

  def self.call(user:, password:)
    # `fake_secret` is a hashed string of 'xxxxxx' with the default pepper.
    fake_secret = '$2a$12$spVnVb9KnpswJhqU3cbCiucCvciHvHD09bpo62CoIVfXl1bwiNuXi'
    reference_hashed_secret = user&.hashed_secret || fake_secret

    # We attempt to validate the password anyway to avoid a timing attack
    valid_password = Kit::Auth::Services::Password.valid_password?({
      reference_hashed_secret: reference_hashed_secret,
      password:                password,
      pepper:                  ENV['AUTH_PEPPER'],
    })

    if user&.hashed_secret && valid_password
      [:ok, user: user]
    else
      [:error, detail: 'Non existing user or invalid password.']
    end
  end

end
