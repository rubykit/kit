module Kit::Admin::Services::Renderers::Attributes::PreYaml

  def self.call(el:, ctx:, functor:, **)
    value = functor.call(el)

    value = value
      .to_yaml
      .gsub("---\n", '')
      .gsub("--- ",  '')

    ctx.pre value
  end

end
