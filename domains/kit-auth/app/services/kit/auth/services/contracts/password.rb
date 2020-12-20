require 'strong_password'

module Kit::Auth::Services::Contracts::Password

  def self.validate(password:, password_confirmation:)
    status, ctx = Kit::Contract::Services::Validation.all(
      contracts: [
        self.method(:check_length),
        self.method(:check_complexity),
        self.method(:check_confirmation),
      ],
      args:      [{
        password:              password,
        password_confirmation: password_confirmation,
      }],
    )

    [status, ctx]
  end

  def self.check_length(password:)
    if password.size < 10 || password.size > 128
      [:error, detail: 'Please use a password longer than 10 characters and shorter than 128.', attribute: :password]
    else
      [:ok]
    end
  end

  def self.check_complexity(password:)
=begin
    checker = StrongPassword::StrengthChecker.new(use_dictionary: true)
    if !checker.is_strong?(password)
      [:error, 'This is a terrible password, please use another one!']
    end
=end

    if password =~ %r{(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[\W_])}
      [:ok]
    else
      [:error, detail: 'Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character.', attribute: :password]
    end
  end

  def self.check_confirmation(password:, password_confirmation:)
    if password == password_confirmation
      [:ok]
    else
      [:error, detail: 'Password confirmation does not match.', attribute: :password_confirmation]
    end
  end

end
