module Yard::Kit::Services::Methods

  # @note Does not include `verifiers`
  def self.get_alias_target(method:)
    target = nil

    if method.is_alias?
      target_method_name = method.namespace.aliases
        .map { |o, aname| (o.scope == method.scope && o.name == method.name) ? aname : nil }
        .compact
        .first

      if target_method_name
        target = method.namespace.children
          .select { |o| o.is_a?(::YARD::CodeObjects::MethodObject) && o.scope == method.scope && o.name == target_method_name }
          .first
      end
    end

    target
  end

end