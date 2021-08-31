# Segment analytics component
class Kit::Domain::Components::Analytics::SegmentComponent < Kit::Domain::Components::MetaComponent

  attr_reader :router_request, :key

  def initialize(*, router_request:, analytics_segment_key: nil, **)
    super

    @router_request = router_request

    set_key(analytics_segment_key)
  end

  def set_key(value = nil) # rubocop:disable Naming/AccessorMethodName
    @key = value || router_request.dig(:metadata, :js_env, :analytics, :segment_key)
  end

end
