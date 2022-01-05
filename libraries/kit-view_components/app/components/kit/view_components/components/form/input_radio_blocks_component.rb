class Kit::ViewComponents::Components::Form::InputRadioBlocksComponent < Kit::ViewComponents::Components::Form::InputRadioGroupComponent

  attr_reader :col_box_class

  def initialize(col_box_class: nil,  **)
    super

    @col_box_class = col_box_class || 'col-sm-6 px-2'
  end

end
