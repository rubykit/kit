# Shared logic for any Domain Component
class Kit::ViewComponents::Components::Form::InputComponent < Kit::ViewComponents::Components::BaseComponent

  attr_reader :help, :label, :name, :value, :errors, :ids, :info, :input_type, :placeholder, :required, :input_class, :info_under_label, :col_input_class, :col_label_class

  def initialize(name:, label: nil, value: nil, help: nil, info: nil, placeholder: nil, required: false, input_class: nil, info_under_label: nil, col_input_class: nil, col_label_class: nil, errors: nil, **)
    super

    @label            = label
    @name             = name.to_s
    @placeholder      = placeholder || label
    @value            = value
    @info             = info
    @errors           = errors || []
    @required         = required == nil ? false : required

    @col_label_class  = col_label_class || 'col-sm-3'
    @col_input_class  = col_input_class || 'col-sm-9'

    @info_under_label = info_under_label

    @input_class = input_class || []
  end

  def input_id
    id || random_id(name)
  end

  def help_id
    "#{ input_id }-help"
  end

  def input_class_to_s
    list = input_class.dup

    error_class = 'is-invalid'
    if errors_list.size > 0 && !list.include?(error_class)
      list << error_class
    end

    list.join(' ')
  end

end
