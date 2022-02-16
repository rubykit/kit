module Kit::Admin::Services::Renderers::Attributes::ModelVerbose

  def self.call(el:, ctx:, functor:, **)
    el   = functor.call(el)
    text = el.try(:model_verbose_name)

    ctx.code(ctx.auto_link(el, text))
  end

end