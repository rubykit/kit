require 'bcrypt'

class Kit::Auth::Interactors::VerifyUserWithPassword
  include Contracts

  Contract Hash => [Symbol, KeywordArgs[verified_user: Any]]
  def self.call(email:, password:, **)
    user     = Models::User::Read.find_by(email: email)

    reference_hashed_secret = user.try(:hashed_secret) || "FAKE_HASHED_SECRET"

    # We attempt to validate the password anyway to avoid a timing attack
    valid_password = valid_password?({
      reference_hashed_secret: reference_hashed_secret,
      password:                password,
      pepper:                  ENV['AUTH_PEPPER'],
    )
    verified = !!user && valid_password

    [:ok, verified_user: verified]
  end

  Contract KeywordArgs[reference_hashed_secret: String, password: String, pepper: String] => Bool
  def self.valid_secret?(reference_hashed_secret:, password:, pepper:)
    bcrypt        = ::BCrypt::Password.new(reference_hashed_secret)
    salt          = bcrypt.salt

    secret        = "#{password}#{pepper}"
    hashed_secret = ::BCrypt::Engine.hash_secret(secret, salt)

    time_insensitive_compare(reference_hashed_secret, hashed_secret)
  end

  # From Devise: constant-time comparison algorithm to prevent timing attacks
  Contract String, String => Bool
  def self.time_insensitive_compare(a, b)
    return false if a.blank? || b.blank? || a.bytesize != b.bytesize
    l = a.unpack "C#{a.bytesize}"

    res = 0
    b.each_byte { |byte| res |= byte ^ l.shift }
    res == 0
  end

end