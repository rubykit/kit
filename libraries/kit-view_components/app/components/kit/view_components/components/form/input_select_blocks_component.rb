class Kit::ViewComponents::Components::Form::InputSelectBlocksComponent < Kit::ViewComponents::Components::Form::InputComponent

  attr_reader :values

  def initialize(*, values:,  **)
    super

    @value  = value || []
    @values = values
  end

  def list_values
    values.each_with_index.map do |el, idx|
      {
        label:    el[1] || el[0],
        value:    el[0],
        selected: value.include?(el[0]),
        input_id: "#{ input_id }_#{ idx }",
      }
    end
  end

end
