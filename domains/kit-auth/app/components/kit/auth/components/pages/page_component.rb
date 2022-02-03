class Kit::Auth::Components::Pages::PageComponent < Kit::Auth::Components::Component

  attr_reader :csrf_token

  def initialize(csrf_token: nil, **)
    super
    @csrf_token = csrf_token
  end

end
