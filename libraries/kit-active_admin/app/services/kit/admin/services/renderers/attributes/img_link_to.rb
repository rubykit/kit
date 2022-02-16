module Kit::Admin::Services::Renderers::Attributes::ImgLinkTo

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    if value[1] && value[2]
      ctx.link_to(ctx.image_tag(value[1], value[3]), value[2])
    else
      ctx.code 'MISSING IMAGE'
    end
  end

end
