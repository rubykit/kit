module Kit::Admin::Services::Renderers::Attributes::Color

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    if value.is_a?(Array)
      value.each do |v|
        ctx.color_tag v
      end
    else
      ctx.color_tag value
    end
  end

end