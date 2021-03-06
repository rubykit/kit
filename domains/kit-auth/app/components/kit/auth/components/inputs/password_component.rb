module Kit::Auth::Components::Inputs
  class PasswordComponent < Kit::Auth::Components::Inputs::InputComponent

    attr_reader :visible

    def initialize(label:, name:, value:, help: nil, errors: [], visible: false, **)
      super
      @input_type = 'password'
      @visible    = visible
    end

  end
end
