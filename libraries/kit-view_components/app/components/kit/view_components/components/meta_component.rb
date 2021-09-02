# Meta elements + title
class Kit::ViewComponents::Components::MetaComponent < Kit::ViewComponents::Components::BaseComponent

  attr_reader :router_request

  def initialize(*, router_request:, **)
    super

    @router_request = router_request
  end

  def meta
    router_request[:metadata][:meta] || {}
  end

end
