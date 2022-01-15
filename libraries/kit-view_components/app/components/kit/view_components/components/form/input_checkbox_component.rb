class Kit::ViewComponents::Components::Form::InputCheckboxComponent < Kit::ViewComponents::Components::Form::InputComponent

  attr_reader :selected

  def initialize(selected: nil,  **)
    super

    @selected   = selected || false
    @input_type = 'checkbox'
  end

end
