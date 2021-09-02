# Meta elements + title
class Kit::UiComponents::Components::MetaComponent < Kit::UiComponents::Components::BaseComponent

  attr_reader :router_request

  def initialize(*, router_request:, **)
    super

    @router_request = router_request
  end

  def meta
    router_request[:metadata][:meta] || {}
  end

end
