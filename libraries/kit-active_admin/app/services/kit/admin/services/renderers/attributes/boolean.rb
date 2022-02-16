module Kit::Admin::Services::Renderers::Attributes::Boolean

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    ctx.color_tag(!!value)
  end

end
