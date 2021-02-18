module Kit::Auth::Components::Forms
  class SignupForm < Kit::Auth::Components::Forms::Form

    def initialize(*, **) # rubocop:disable Lint/UselessMethodDefinition
      super
    end

    def fields_name
      [:email, :password, :password_confirmation, :email_confirmation]
    end

  end
end
