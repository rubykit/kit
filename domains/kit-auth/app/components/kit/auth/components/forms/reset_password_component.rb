module Kit::Auth::Components::Forms
  class ResetPasswordComponent < Kit::Auth::Components::Forms::FormComponent

    def initialize(auth_token_secret:, **)
      super
      @auth_token_secret = auth_token_secret
    end

    def fields_name
      [:password, :password_confirmation]
    end

  end
end
