module Kit::Auth::Components::Various
  class FlashComponent < Kit::Auth::Components::Component

    attr_reader :flash

    def initialize(flash:, **)
      super
      @flash = flash
    end

    def flash_type_to_bootstrap_type(type)
      case type.to_sym
      when :alert
        'danger'
      when :notice
        'info'
      else
        type
      end
    end

  end
end
