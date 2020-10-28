module Kit::Auth::Components::Inputs
  class Password < Kit::Auth::Components::Inputs::Input

    attr_reader :visible

    def initialize(label:, name:, value:, help: nil, errors: [], visible: false, **)
      super
      @input_type = 'password'
      @visible    = visible
    end

  end
end
