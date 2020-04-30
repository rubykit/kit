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

  # Might be used on a constant
  def self.attributes_container_classes(item:)
    deprecated   = item.has_tag?(:deprecated)
    private_api  = item.has_tag?(:api) && item.tag(:api).text == 'private'
    visibility   = item&.respond_to?(:visibility) ? item.visibility : nil

    list = []

    if visibility
      list << "attr-visibility-#{visibility}"
    end
    if deprecated
      list << 'attribute-deprecated'
    end
    if private_api
      list << 'attribute-private-api'
    end

    list
  end

end