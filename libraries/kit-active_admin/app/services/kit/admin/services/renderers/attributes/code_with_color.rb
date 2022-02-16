module Kit::Admin::Services::Renderers::Attributes::CodeWithColor

  def self.call(el:, ctx:, functor:, **)
    color_tag, code = functor.call(el)

    ctx.span do
      ctx.color_tag color_tag
      ctx.code      code, style: 'margin-left: 5px;'
    end
  end

end
