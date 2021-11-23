class Kit::Auth::Components::Pages::Users::Settings::Sessions::IndexComponent < Kit::Auth::Components::Pages::PageComponent

  attr_reader :list

  def initialize(list:, **)
    super
    @list = list
  end

end
