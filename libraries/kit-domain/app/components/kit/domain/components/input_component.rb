# Shared logic for any Domain Component
class Kit::Domain::Components::InputComponent < Kit::Domain::Components::Component

  attr_reader :help, :label, :name, :value, :errors, :ids, :info, :input_type, :placeholder, :required

  def initialize(name:, label: nil, value: nil, help: nil, info: nil, placeholder: nil, required: false, errors: [], **)
    super

    @label       = label
    @name        = name.to_s
    @placeholder = placeholder || label
    @value       = value
    @info        = info
    @errors      = errors
    @required    = required
  end

  def input_id
    id || random_id(name)
  end

  def help_id
    "#{ input_id }-help"
  end

end
