module Kit::Admin::Services::Renderers::Attributes::ModelColor

  def self.call(el:, ctx:, functor:, **)
    object = functor.call(el)

    if object
      str = "##{ object.id } #{ object.uid.upcase }"

      ctx.a href: ctx.auto_url_for(object) do
        ctx.status_tag(str, class: "#{ object.model_name.element }_#{ object.uid }")
      end
    else
      nil
    end
  end

end