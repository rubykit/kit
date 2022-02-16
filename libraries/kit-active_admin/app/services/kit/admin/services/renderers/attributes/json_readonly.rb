module Kit::Admin::Services::Renderers::Attributes::JsonReadonly

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    ctx.div class: 'container_json_editor_readonly' do
      ctx.textarea JSON.pretty_generate(value), class: 'json_editor_readonly', style: 'display: none;'
    end
  end

end
