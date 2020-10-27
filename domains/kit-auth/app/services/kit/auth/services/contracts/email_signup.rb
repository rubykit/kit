require 'dry-validation'
require 'email_inquire'

class Kit::Auth::Services::Contracts::EmailSignup < Dry::Validation::Contract

  params do
    required(:email).filled(:string)
    optional(:email_confirmation)
  end

  rule(:email, :email_confirmation) do
    response = EmailInquire.validate(values[:email])

    if response.status == :invalid
      key.failure('has invalid format')
    # NOTE: should this be here?
    elsif response.status == :hint && values[:email] != values[:email_confirmation]
      key.failure("Did you mean #{ response.replacement } ?")
    end
  end

end
