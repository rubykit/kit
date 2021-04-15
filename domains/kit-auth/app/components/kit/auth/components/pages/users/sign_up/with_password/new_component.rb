module Kit::Auth::Components::Pages::Users::SignUp::WithPassword
  class NewComponent < Kit::Auth::Components::Pages::PageComponent

    attr_reader :model

    def initialize(model:, **)
      super
      @model = model
    end

  end
end
