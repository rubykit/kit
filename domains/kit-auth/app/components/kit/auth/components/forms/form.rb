module Kit::Auth::Components::Forms
  class Form < Kit::Auth::Components::Component

    attr_reader :csrf_token, :model, :errors_list

    def initialize(model:, csrf_token: nil, errors_list: [], **)
      super

      @csrf_token  = csrf_token
      @model       = model
      @errors_list = errors_list || []
    end

    def generic_errors
      @generic_errors ||= errors_list
        .reject { |el| fields_name.include?(el[:attribute]) } || []
    end

    def errors_by_field
      if !defined?(@_errors_by_field)
        list = errors_list.group_by { |v| v[:attribute] }
        fields_name.each do |field|
          if !list[field]
            list[field] = []
          end
        end

        @_errors_by_field = list
      end

      @_errors_by_field
    end

    def fields_name
      raise 'IMPLEMENT ME'
    end

  end
end
