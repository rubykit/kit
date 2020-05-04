module Kit::Auth::Components::Forms
  class ResetPasswordRequest < Kit::Auth::Components::Forms::Form

    def initialize(*)
      super
    end

    def fields_name
      [:email]
    end

  end
end