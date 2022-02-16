module Kit::Admin::Services::Renderers::Attributes::ModelId

  def self.call(el:, ctx:, functor:, name:, **)
    if name == :id
      ctx.code(ctx.auto_link el, "##{el.id}")
    else
      el   = functor.call(el)
      text = "##{ el.try(:id).try(:to_s) }"

      ctx.code(ctx.auto_link(el, text))
    end
  end

end
