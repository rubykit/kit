module Kit::Admin::Services::Renderers::Attributes::LinkTo

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    ctx.send :link_to, *value
  end

end
