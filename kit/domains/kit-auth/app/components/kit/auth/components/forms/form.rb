require 'observer'

=begin
class Array
  include Observable
end
=end

module Kit::Auth::Components::Forms

=begin
  class ArrayObserver
    def initialize(array)
      if array.is_a?(Array)
        array.add_observer(self)
      end
    end

    def update(*args)
      binding.pry
    end
  end
=end

  class Form < Kit::Domain::Components::Component
    attr_reader :csrf_token, :model, :errors_list

    def initialize(csrf_token: nil, model:, errors_list: [], **)
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

        #ArrayObserver.new(list[:email])

        @_errors_by_field = list
      end

      @_errors_by_field
    end

    def fields_name
      raise "IMPLEMENT ME"
    end

  end
end