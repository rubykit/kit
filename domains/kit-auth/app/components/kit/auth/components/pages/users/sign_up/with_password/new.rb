module Kit::Auth::Components::Pages::Users::SignUp::WithPassword
  class New < Kit::Auth::Components::Pages::Page

    attr_reader :model

    def initialize(model:, **)
      super
      @model = model
    end

  end
end
