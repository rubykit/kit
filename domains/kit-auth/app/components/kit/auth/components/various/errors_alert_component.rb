module Kit::Auth::Components::Various
  class ErrorsAlertComponent < Kit::Auth::Components::Component

    attr_reader :errors

    def initialize(errors: [], **)
      super
      @errors = errors
    end

  end
end
