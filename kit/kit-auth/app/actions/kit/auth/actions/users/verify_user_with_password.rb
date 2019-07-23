require 'bcrypt'

class Kit::Auth::Actions::Users::VerifyUserWithPassword
  include Contracts

  Contract Hash => [Symbol, KeywordArgs[verified_user: Any]]
  def self.call(email:, password:, **)
    user     = Models::User::Read.find_by(email: email)

    reference_hashed_secret = user.try(:hashed_secret) || "FAKE_HASHED_SECRET"

    # We attempt to validate the password anyway to avoid a timing attack
    valid_password = Kit::Auth::Services::Password.valid_password?({
      reference_hashed_secret: reference_hashed_secret,
      password:                password,
      pepper:                  ENV['AUTH_PEPPER'],
    )
    verified = !!user && valid_password

    [:ok, verified_user: verified]
  end

end