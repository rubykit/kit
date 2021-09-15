require 'oj'

# Add some global JS env in the page.
class Kit::ViewComponents::Components::JsEnvComponent < Kit::ViewComponents::Components::BaseComponent

  attr_reader :router_conn

  def initialize(*, router_conn:, **)
    super

    @router_conn = router_conn
  end

  def js_env
    router_conn.dig(:metadata, :js_env) || {}
  end

  def js_payload
    Oj.dump(js_env, mode: :compat).html_safe
  end

end
