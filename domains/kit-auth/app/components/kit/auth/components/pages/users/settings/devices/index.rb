module Kit::Auth::Components::Pages::Users::Settings::Devices
  class Index < Kit::Auth::Components::Pages::Page

    attr_reader :list

    def initialize(list:, **)
      super
      @list = list
    end

  end
end
