# Default Navbar.
class Components::Navbar < ::ViewComponent::Base

  attr_reader :args

  def initialize(**args) # rubocop:disable Lint/UselessMethodDefinition
    super

    @args = args
  end

end
