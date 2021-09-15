# Google analytics component
class Kit::ViewComponents::Components::Analytics::GoogleComponent < Kit::ViewComponents::Components::MetaComponent

  attr_reader :router_conn, :mid

  def initialize(*, router_conn:, analytics_google_mid: nil, **)
    super

    @router_conn = router_conn

    set_mid(analytics_google_mid)
  end

  def set_mid(value = nil) # rubocop:disable Naming/AccessorMethodName
    @mid = value || router_conn.dig(:metadata, :js_env, :analytics, :google_mid) || ENV['ANALYTICS_GA_MID']
  end

end
