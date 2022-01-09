class Kit::ViewComponents::Components::Form::InputTextComponent < Kit::ViewComponents::Components::Form::InputComponent

  attr_reader :mask

  def initialize(*, mask: nil, **)
    super

    @input_type = 'text'

    @mask = mask.is_a?(String) ? mask : mask.to_json
  end

end
