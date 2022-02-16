module Kit::Admin::Services::Renderers::Attributes::Model

  def self.call(el:, ctx:, functor:, **)
    el   = functor.call(el)
    text = el.try(:model_log_name)

    ctx.code(ctx.auto_link(el, text))
  end

end
