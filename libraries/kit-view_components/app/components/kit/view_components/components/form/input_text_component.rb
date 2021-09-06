class Kit::ViewComponents::Components::Form::InputTextComponent < Kit::ViewComponents::Components::Form::InputComponent

  attr_reader :mask, :mask_placeholder

  def initialize(*, mask: nil, mask_placeholder: nil, **)
    super

    @input_type = 'text'

    @mask             = mask
    @mask_placeholder = mask_placeholder
  end

end
