# Segment analytics component
class Kit::ViewComponents::Components::Analytics::SegmentComponent < Kit::ViewComponents::Components::MetaComponent

  attr_reader :router_conn, :key

  def initialize(*, router_conn:, analytics_segment_key: nil, **)
    super

    @router_conn = router_conn

    set_key(analytics_segment_key)
  end

  def set_key(value = nil) # rubocop:disable Naming/AccessorMethodName
    @key = value || router_conn.dig(:metadata, :js_env, :analytics, :segment_key)
  end

end
