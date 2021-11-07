class Kit::Auth::Components::Pages::Users::Settings::Oauth::IndexComponent < Kit::Auth::Components::Pages::PageComponent

  attr_reader :list

  def initialize(list:, **)
    super
    @list = list
  end

end
