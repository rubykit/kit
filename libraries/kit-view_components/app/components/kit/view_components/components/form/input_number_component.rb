class Kit::ViewComponents::Components::Form::InputNumberComponent < Kit::ViewComponents::Components::Form::InputTextComponent

  def initialize(*,  **)
    super

    @input_type = 'number'
  end

end
