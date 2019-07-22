require 'bcrypt'

=begin
class NewUserContract < Dry::Validation::Contract
  params do
    required(:email).filled(:string)
    required(:password).filled(min_size?: 12, max_size: 128)
  end

  rule(:email) do
    unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
      key.failure('has invalid format')
    end
  end
end
=end

class Kit::Auth::Interactors::CreateUserWithPassword
  include Contracts

  Contract Hash => [Symbol, KeywordArgs[user: Any, errors: Any]]
  def self.call(email:, password:, **)

    #contract = NewUserContract.new.call(email: email, password: password)

    hashed_secret = generate_hashed_secret({
      password: password,
      pepper:   ENV['AUTH_PEPPER'],
    })

    email = email.downcase.strip

    user  = Kit::Auth::Models::Write::User.create({
      email:         email,
      hashed_secret: hashed_secret,
    })

    if user.persisted?
      [:ok, user: user]
    else
      [:error, user: nil, errors: user.errors]
    end
  end

  def validate(*args)

  end

  Contract KeywordArgs[password: String, pepper: String] => String
  def self.generate_hashed_secret(password:, pepper:)
    secret        = "#{password}#{pepper}"
    hashed_secret = ::BCrypt::Password.create(password, cost: 12).to_s
  end

end