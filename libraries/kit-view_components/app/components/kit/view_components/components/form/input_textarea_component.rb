class Kit::ViewComponents::Components::Form::InputTextareaComponent < Kit::ViewComponents::Components::Form::InputComponent

  attr_reader :rows, :maxlength

  def initialize(*, rows: nil, maxlength: nil, **)
    super

    @rows      = rows
    @maxlength = maxlength
  end

end
