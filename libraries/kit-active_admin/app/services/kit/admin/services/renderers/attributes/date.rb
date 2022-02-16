module Kit::Admin::Services::Renderers::Attributes::Date

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    ctx.date_tag value
  end

end
