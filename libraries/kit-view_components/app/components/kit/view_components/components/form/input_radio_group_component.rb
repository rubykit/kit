class Kit::ViewComponents::Components::Form::InputRadioGroupComponent < Kit::ViewComponents::Components::Form::InputComponent

  attr_reader :values

  def initialize(*, values:,  **)
    super

    @values = values
  end

  def list_values
    values.each_with_index.map do |el, idx|
      {
        label:    el[1] || el[0],
        value:    el[0],
        selected: el[0] == value,
        input_id: "#{ input_id }_#{ idx }",
      }
    end
  end

end
