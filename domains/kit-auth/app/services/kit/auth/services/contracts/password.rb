require 'dry-validation'
require 'strong_password'

class Kit::Auth::Services::Contracts::Password < Dry::Validation::Contract

  params do
    required(:password).filled(min_size?: 10, max_size?: 128)
    required(:password_confirmation)
  end

  rule(:password) do
    if !(value =~ %r{(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[\W_])})
      key.failure('Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character.')
=begin
    else
      checker = StrongPassword::StrengthChecker.new(use_dictionary: true)
      if !checker.is_strong?(value)
        key.failure('is a terrible password, please use another one!')
      end
=end
    end
  end

  rule(:password_confirmation, :password) do
    if values[:password] != values[:password_confirmation]
      key.failure('Password confirmation does not match.')
    end
  end

end
