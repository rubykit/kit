module Kit::Admin::Services::Renderers::Attributes::Amount

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    ctx.amount_tag value
  end

end
