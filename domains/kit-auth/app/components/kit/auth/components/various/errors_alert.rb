module Kit::Auth::Components::Various
  class ErrorsAlert < Kit::Auth::Components::Component

    attr_reader :errors

    def initialize(errors: [], **)
      super
      @errors = errors
    end

  end
end
