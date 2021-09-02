require 'oj'

# Add some global JS env in the page.
class Kit::UiComponents::Components::JsEnvComponent < Kit::UiComponents::Components::BaseComponent

  attr_reader :router_request

  def initialize(*, router_request:, **)
    super

    @router_request = router_request
  end

  def js_env
    router_request.dig(:metadata, :js_env) || {}
  end

  def js_payload
    Oj.dump(js_env, mode: :compat).html_safe
  end

end
