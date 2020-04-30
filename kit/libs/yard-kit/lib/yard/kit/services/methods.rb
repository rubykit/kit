module Yard::Kit::Services::Methods

  # @note Does not include `verifiers`
  def self.get_alias_target(method:)
    is_alias     = false
    alias_target = nil

    if method.is_a?(::YARD::CodeObjects::MethodObject) && method.is_alias?
      is_alias = true

      target_method_name = method.namespace.aliases
        .map { |o, aname| (o.scope == method.scope && o.name == method.name) ? aname : nil }
        .compact
        .first

      if target_method_name
        alias_target = method.namespace.children
          .select { |o| o.is_a?(::YARD::CodeObjects::MethodObject) && o.scope == method.scope && o.name == target_method_name }
          .first
      end
    end

    { is_alias: is_alias, alias_target: alias_target }
  end

end