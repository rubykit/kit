module Kit::Auth::Components::Inputs
  class EmailComponent < Kit::Auth::Components::Inputs::InputComponent

    def initialize(*, **)
      super
      @input_type = 'email'
    end

  end
end
