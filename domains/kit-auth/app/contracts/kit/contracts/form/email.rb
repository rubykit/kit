require 'email_inquire'

# Use `emain_inquire` to validate emails.
#
# ### References
# - https://github.com/maximeg/email_inquire
#
module Kit::Contracts::Form::Email

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

  def self.check_format(email:)
    response = EmailInquire.validate(email)

    if response.status == :invalid
      [:error, detail: 'This email is not valid.', attribute: :email]
    else
      [:ok]
    end
  end

end
