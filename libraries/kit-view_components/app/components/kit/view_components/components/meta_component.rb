# Meta elements + title
class Kit::ViewComponents::Components::MetaComponent < Kit::ViewComponents::Components::BaseComponent

  attr_reader router_conn:

  def initialize(*, router_conn:, **)
    super

    @router_conn = router_conn
  end

  def meta
    router_conn[:metadata][:meta] || {}
  end

end
