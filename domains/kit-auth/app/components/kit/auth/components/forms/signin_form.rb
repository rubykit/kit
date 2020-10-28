module Kit::Auth::Components::Forms
  class SigninForm < Kit::Auth::Components::Forms::Form

    def initialize(*) # rubocop:disable Lint/UselessMethodDefinition
      super
    end

    def fields_name
      [:email, :password]
    end

  end
end
