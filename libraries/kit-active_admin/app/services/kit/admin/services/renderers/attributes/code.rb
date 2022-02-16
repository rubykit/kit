module Kit::Admin::Services::Renderers::Attributes::Code

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    ctx.code value
  end

end
