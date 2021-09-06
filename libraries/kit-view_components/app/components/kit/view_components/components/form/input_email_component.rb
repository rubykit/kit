class Kit::ViewComponents::Components::Form::InputEmailComponent < Kit::ViewComponents::Components::Form::InputTextComponent

  def initialize(*,  **)
    super

    @input_type = 'email'
  end

end
