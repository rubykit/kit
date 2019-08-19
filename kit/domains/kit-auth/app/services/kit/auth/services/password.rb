require 'bcrypt'

module Kit::Auth::Services::Password

  #Contract KeywordArgs[password: String, pepper: String] => [Symbol, KeywordArgs[hashed_secret: String]]
  def self.generate_hashed_secret(password:, pepper: ENV['AUTH_PEPPER'])
    secret        = "#{password}#{pepper}"
    hashed_secret = ::BCrypt::Password.create(password, cost: 12).to_s

    [:ok, hashed_secret: hashed_secret]
  end

  #Contract KeywordArgs[reference_hashed_secret: String, password: String, pepper: String] => Bool
  def self.valid_password?(reference_hashed_secret:, password:, pepper: ENV['AUTH_PEPPER'])
    bcrypt        = ::BCrypt::Password.new(reference_hashed_secret)
    salt          = bcrypt.salt

    secret        = "#{password}#{pepper}"
    hashed_secret = ::BCrypt::Engine.hash_secret(secret, salt)

    ActiveSupport::SecurityUtils.secure_compare(reference_hashed_secret, hashed_secret)
  end

end