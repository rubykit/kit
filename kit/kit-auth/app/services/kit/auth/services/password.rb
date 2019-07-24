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

    time_insensitive_compare(reference_hashed_secret, hashed_secret)
  end

  # From Devise: constant-time comparison algorithm to prevent timing attacks
  #Contract String, String => Bool
  def self.time_insensitive_compare(a, b)
    return false if a.blank? || b.blank? || a.bytesize != b.bytesize
    l = a.unpack "C#{a.bytesize}"

    res = 0
    b.each_byte { |byte| res |= byte ^ l.shift }
    res == 0
  end

end