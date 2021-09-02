module Kit::Auth::Components
  class Component < Kit::ViewComponents::Components::BaseComponent

    attr_reader :errors_list

    def initialize(errors_list: [], **)
      super
      @errors_list = errors_list
    end

  end
end
