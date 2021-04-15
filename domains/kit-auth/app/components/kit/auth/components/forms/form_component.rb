module Kit::Auth::Components::Forms
  class FormComponent < Kit::Auth::Components::Component

    attr_reader :csrf_token, :model, :errors_list

    def initialize(model:, csrf_token: nil, errors_list: [], **)
      super

      @csrf_token  = csrf_token
      @model       = model
      @errors_list = [errors_list].flatten || []

      @errors_list.each do |el|
        if el[:detail].include?('$attribute') && el[:attribute]
          el[:detail].gsub!('$attribute', el[:attribute].to_s)
        end
      end
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
