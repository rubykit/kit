module Kit::Admin::Services::Renderers::Attributes::CodeLinkTo

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el: el, routes: Rails.application.routes.url_helpers)

    ctx.code ctx.send(:link_to, *value)
  end

end
