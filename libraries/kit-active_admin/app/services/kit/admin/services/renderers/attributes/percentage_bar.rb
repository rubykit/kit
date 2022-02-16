module Kit::Admin::Services::Renderers::Attributes::PercentageBar

  def self.call(el:, ctx:, functor:, **)
    ctx.div(class: 'progress') do
      value = functor.call(el)

      ctx.div(class: 'progress-bar', role: 'progressbar', style: "width: #{ value.to_i }%;", :'aria-valuenow' => value.to_i, :'aria-valuemin' => '0', :'aria-valuemax' => '100') do
        '% 2.2f%' % value
      end
    end
  end

end
