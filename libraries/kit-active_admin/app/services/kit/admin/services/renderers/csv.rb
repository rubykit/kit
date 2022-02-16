module Kit::Admin::Services::Renderers::Csv

  def self.render(ctx:, relation:, attrs:)
    attrs.each do |name, body|
      ctx.send(:column, name) do |el|
        case body
          when Symbol, NilClass
            body_nil_for_csv(ctx: ctx, el: el, name: name)
          when Array
            body_functor_for_csv(ctx: ctx, name: name, functor: body[1])
          when Proc
            body_functor_for_csv(ctx: ctx, name: name, functor: body)
          else
            raise "CSV export: unhandled type for `#{ name }`, got: `#{ body.class }`"
        end
      end
    end
  end

  def self.body_nil_for_csv(ctx:, el:, name:)
    value = el.send(name)

    case value
      when ActiveRecord::Base
        value.id
      when Date, Time
        value.to_datetime.iso8601
      else
        value
    end
  end

  def self.body_functor_for_csv(ctx:, el:, name:, functor:)
    value = functor.call(el)

    if value.is_a?(Array)
      value = value[0]
    end

    if value.is_a?(ApplicationRecord)
      value.id
    else
      value
    end
  end

end
