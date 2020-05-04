require 'dry-validation'
require 'email_inquire'

class Kit::Auth::Services::Contracts::Email < Dry::Validation::Contract

  params do
    required(:email).filled(:string)
  end

  rule(:email) do
    response = EmailInquire.validate(values[:email])

    if response.status == :invalid
      key.failure('has invalid format')
    end
  end

end
