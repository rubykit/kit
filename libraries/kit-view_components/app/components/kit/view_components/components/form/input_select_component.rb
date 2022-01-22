class Kit::ViewComponents::Components::Form::InputSelectComponent < Kit::ViewComponents::Components::Form::InputComponent

  attr_reader :values, :select2

  def initialize(*, values:, select2: nil, **)
    super

    @value   = value || []
    @values  = values
    @select2 = select2 || false
  end

  def list_values
    values
      .each_with_index.map do |el, idx|
        if el.is_a?(Array)
          {
            label:    el[1] || el[0],
            value:    el[0],
            selected: value.include?(el[0]),
            input_id: "#{ input_id }_#{ idx }",
          }
        elsif el.is_a?(Hash)
          el[:label]    = el[:label] || el[:value]
          el[:selected] = (el[:selected] != nil) ? el[:selected] : value.include?(el[:value])
          el[:input_id] = el[:input_id] || "#{ input_id }_#{ idx }"
          el
        else
          nil
        end
      end
      .reject(&:empty?)
  end

  def data_control
    select2 ? 'select2' : nil
  end

end
