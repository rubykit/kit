class Kit::ViewComponents::Components::Form::InputRadioGroupComponent < Kit::ViewComponents::Components::Form::InputComponent

  attr_reader :values, :vertical

  def initialize(*, values:, vertical: nil, **)
    super

    @values   = values
    @vertical = vertical || false
  end

  # TODO: audit the ".to_s"?
  def list_values
    values.each_with_index.map do |el, idx|
      {
        label:    el[1] || el[0],
        value:    el[0],
        selected: el[0] == value || el[0] == value.to_s,
        input_id: "#{ input_id }_#{ idx }",
      }
    end
  end

  def input_group_class
    list = []

    if errors_list.size > 0
      list << 'is-invalid'
    end

    if vertical
      list << 'input-group-vertical'
    end

    list.join(' ')
  end

end
