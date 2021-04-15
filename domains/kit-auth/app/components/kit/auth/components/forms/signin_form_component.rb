module Kit::Auth::Components::Forms
  class SigninFormComponent < Kit::Auth::Components::Forms::FormComponent

    def initialize(*, **) # rubocop:disable Lint/UselessMethodDefinition
      super
    end

    def fields_name
      [:email, :password]
    end

  end
end
