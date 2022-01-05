class Kit::ViewComponents::Components::Form::InputSelectBlocksComponent < Kit::ViewComponents::Components::Form::InputComponent

  attr_reader :values, :col_box_class

  def initialize(*, values:, col_box_class: nil,  **)
    super

    @value  = value || []
    @values = values

    @col_box_class = col_box_class || 'col-sm-6 px-2'
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
