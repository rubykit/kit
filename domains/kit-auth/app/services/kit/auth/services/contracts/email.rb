require 'email_inquire'

module Kit::Auth::Services::Contracts::Email

  def self.validate(email:)
    Kit::Contract::Services::Validation.all(
      contracts:  [
        self.method(:check_format),
      ],
      parameters: {
        kwargs: {
          email: email,
        },
      },
    )
  end

  def self.check_format(email:, email_confirmation: nil)
    response = EmailInquire.validate(email)

    if response.status == :invalid
      [:error, detail: 'This email is not valid.', attribute: :email]
    else
      [:ok]
    end
  end

end
