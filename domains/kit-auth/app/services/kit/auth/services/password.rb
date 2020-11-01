require 'bcrypt'

# Service that contains password related logic.
module Kit::Auth::Services::Password

  def self.generate_hashed_secret(password:, pepper: ENV['AUTH_PEPPER'])
    secret        = "#{ password }#{ pepper }"
    hashed_secret = ::BCrypt::Password.create(secret, cost: 12).to_s

    [:ok, hashed_secret: hashed_secret]
  end

  def self.valid_password?(reference_hashed_secret:, password:, pepper: ENV['AUTH_PEPPER'])
    bcrypt        = ::BCrypt::Password.new(reference_hashed_secret)
    salt          = bcrypt.salt

    secret        = "#{ password }#{ pepper }"
    hashed_secret = ::BCrypt::Engine.hash_secret(secret, salt)

    ActiveSupport::SecurityUtils.secure_compare(reference_hashed_secret, hashed_secret)
  end

end
