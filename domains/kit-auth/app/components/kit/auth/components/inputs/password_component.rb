class Kit::Auth::Components::Inputs::PasswordComponent < Kit::Auth::Components::Inputs::InputComponent

  attr_reader :visible

  def initialize(**)
    super

    @input_type = 'password'
  end

end
