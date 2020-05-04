module Kit::Auth::Components::Various
  class Alert < Kit::Auth::Components::Component
    attr_reader :type

    def initialize(type:, **)
      super
      @type = type
    end

    def alert_type_class
      if type.in? ['primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark']
        "alert-#{type}"
      else
        nil
      end
    end

  end
end