module Kit::Admin::Services::Renderers

  def self.build_for_html_display(ctx:, type:, attrs:)
    attrs.each do |name, body|
      payload = {
        ctx:  ctx,
        type: type,
        name: name,
        body: body,
      }

      case body
        when Symbol
          payload[:body] = [payload[:body]]
          build_array(**payload)
        when Array
          build_array(**payload)
        when NilClass
          if name == :id
            payload[:body] = [:model_id]
            build_array(**payload)
          else
            # NOTE: we might want to overload this for column & row?
            ctx.send(type, name)
          end
        when Proc
          build_functor(ctx: ctx, type: type, name: name, functor: body)
        else
          raise "Non handled `body`: #{body}"
      end
    end

    [:ok]
  end

  def self.build_array(ctx:, type:, name:, body:)
    attr_type = body[0]
    functor   = body[1]

    if !functor
      if name == :id
        functor = ->(el) { el }
      else
        functor = ->(el) { el.send(name) }
      end
    end

    if attr_type == nil
      build_functor(ctx: ctx, type: type, name: name, functor: functor)
      return
    end

    attr_type = attr_type.to_sym

    if attr_type == :id
      attr_type = :model_id
    end

    callable = Kit::Admin::Services::Renderers::Attributes.types[attr_type]
    if callable
      # NOTE: should we use our own column / row methods?
      ctx.send(type, name) do |el|
        callable.call(el: el, ctx: ctx, functor: functor, name: name)
      end
    else
      raise "Unknown attr_type `#{ attr_type }` or method `#{ method_name }`"
    end
  end

  def self.build_functor(ctx:, type:, name:, functor:)
    ctx.send(type, name) { |el| functor.call el }
  end

end