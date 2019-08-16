module Kit::Auth::Components::Inputs
  class Input < Kit::Domain::Components::Component
    attr_reader :help, :label, :name, :value, :errors, :ids, :input_type, :placeholder

    def initialize(help: nil, label:, name:, placeholder: nil, value:, errors: [], **args)
      @label       = label
      @name        = name
      @placeholder = placeholder || label
      @value       = value
      @errors      = errors
    end

    def input_id
      id || random_id(name)
    end

    def help_id
      "#{input_id}-help"
    end

  end
end