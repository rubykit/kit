module Kit::Auth::Components::Pages::Users::ResetPassword
  class EditComponent < Kit::Auth::Components::Pages::PageComponent

    attr_reader :model

    def initialize(model:, **)
      super
      @model = model
    end

  end
end
