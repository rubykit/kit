module Kit::Admin::Services::Renderers::Attributes::AutoLink

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    if value.is_a? Array
      object = value[0]
      text   = value[1] ? value[1] : object.try(:id)
    else
      object = value
      text   = object.try(:id)
    end

    ctx.auto_link object, text
  end

end
