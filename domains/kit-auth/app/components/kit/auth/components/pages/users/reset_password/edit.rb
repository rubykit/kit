module Kit::Auth::Components::Pages::Users::ResetPassword
  class Edit < Kit::Auth::Components::Pages::Page

    attr_reader :model

    def initialize(model:, **)
      super
      @model = model
    end

  end
end
