require 'email_inquire'

module Kit::Auth::Services::Contracts::EmailSignup

  def self.validate(email:, email_confirmation: nil)
    Kit::Contract::Services::Validation.all(
      contracts: [
        self.method(:check_emptiness),
        self.method(:check_format),
      ],
      args:      [{
        email:              email,
        email_confirmation: email_confirmation,
      }],
    )
  end

  def self.check_emptiness(email:)
    if email.empty?
      [:error, detail: 'The email is empty.', attribute: :email]
    else
      [:ok]
    end
  end

  def self.check_format(email:, email_confirmation: nil)
    response = EmailInquire.validate(email)

    if response.status == :invalid
      [:error, detail: 'This email is not valid.', attribute: :email]
    elsif response.status == :hint && email != email_confirmation
      [:error, detail: "Did you mean #{ response.replacement } ?", attribute: :email, type: :warning]
    else
      [:ok]
    end
  end

end
