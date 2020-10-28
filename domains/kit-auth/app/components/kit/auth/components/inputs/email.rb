module Kit::Auth::Components::Inputs
  class Email < Kit::Auth::Components::Inputs::Input

    def initialize(*)
      super
      @input_type = 'email'
    end

  end
end
