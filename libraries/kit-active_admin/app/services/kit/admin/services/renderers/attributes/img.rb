module Kit::Admin::Services::Renderers::Attributes::Img

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    ctx.img value
  end

end
