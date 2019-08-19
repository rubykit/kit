module Kit::Auth::Components::Inputs
  class Input < Kit::Auth::Components::Component
    attr_reader :help, :label, :name, :value, :errors, :ids, :input_type, :placeholder, :required

    def initialize(help: nil, label:, name:, placeholder: nil, required: false, value:, errors: [], **)
      super

      @label       = label
      @name        = name
      @placeholder = placeholder || label
      @value       = value
      @errors      = errors
      @required    = required
    end

    def input_id
      id || random_id(name)
    end

    def help_id
      "#{input_id}-help"
    end

  end
end