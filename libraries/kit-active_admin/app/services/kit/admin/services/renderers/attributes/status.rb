module Kit::Admin::Services::Renderers::Attributes::Status

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    ctx.status_tag(value[0], value[1])
  end

end