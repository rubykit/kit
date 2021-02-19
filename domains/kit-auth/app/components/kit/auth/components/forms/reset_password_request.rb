module Kit::Auth::Components::Forms
  class ResetPasswordRequest < Kit::Auth::Components::Forms::Form

    def initialize(*, **) # rubocop:disable Lint/UselessMethodDefinition
      super
    end

    def fields_name
      [:email]
    end

  end
end
