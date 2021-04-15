module Kit::Auth::Components::Pages::Users::Settings::Devices
  class IndexComponent < Kit::Auth::Components::Pages::PageComponent

    attr_reader :list

    def initialize(list:, **)
      super
      @list = list
    end

  end
end
