module Kit::Auth::Components::Forms
  class ResetPasswordRequestComponent < Kit::ViewComponents::Components::FormComponent

    def initialize(*, **) # rubocop:disable Lint/UselessMethodDefinition
      super
    end

    def fields_name
      [:email]
    end

  end
end
