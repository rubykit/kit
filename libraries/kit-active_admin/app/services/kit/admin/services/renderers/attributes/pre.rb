module Kit::Admin::Services::Renderers::Attributes::Pre

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    ctx.pre value
  end

end
