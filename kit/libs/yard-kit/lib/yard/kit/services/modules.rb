module Yard::Kit::Services::Modules

  # Methods --------------------------------------------------------------------

  # @note Does not include `verifiers`
  def self.get_methods(object:, options:, include_aliases: true, include_attributes: false, include_inherited: false, include_specials: true, include_instance_methods: true, include_class_methods: true)
    list = object.meths(
      inherited: include_inherited,
      included:  !options.embed_mixins.any?,
    )

    if !include_aliases
      list = list.reject { |el| !(::YARD::CodeObjects::Proxy === el.namespace) && el.is_alias? }
    end

    if !include_attributes
      list = list.reject { |el| !(::YARD::CodeObjects::Proxy === el.namespace) && el.is_attribute? }
    end

    if !include_specials
      list = list.reject { |el| el.constructor? || el.name(true) == '#method_missing' }
    end

    if !include_instance_methods
      list = list.reject { |el| el.scope == :instance }
    end

    if !include_class_methods
      list = list.reject { |el| el.scope == :class }
    end

    if options.embed_mixins.any?
      list = list.reject { |el| options.embed_mixins_match?(el.namespace) == false }
    end

    list
      .sort_by { |el| [el.scope.to_s, el.name.to_s.downcase] }
  end

  def self.get_inherited_methods(object:, options:, include_instance_methods: true, include_class_methods: true, hide_if_overwritten: true)
    list = {}
    method_names = {}

    object.inheritance_tree(true)[1..-1].each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if options.embed_mixins.size > 0 && options.embed_mixins_match?(superclass) != false

      sublist = superclass
        .meths(included: false, inherited: false)
        .reject! { |el| object.child(scope: el.scope, name: el.name) != nil }
        .reject! { |el| el.is_alias? || el.is_attribute? }

      if hide_if_overwritten
        sublist = sublist.reject { |el| method_names[el.name] == true }
        sublist.each { |el| method_names[el.name] = true }
      end

      if !include_instance_methods
        sublist = sublist.reject { |el| el.scope == :instance }
      end

      if !include_class_methods
        sublist = sublist.reject { |el| el.scope == :class }
      end

      next if sublist.size == 0

      list[superclass.name] = { superclass: superclass, list: sublist }
    end

    list
  end


  # Attributes -----------------------------------------------------------------

  def self.get_attributes(object:, options:)
    list = []

    object.inheritance_tree(true).each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if options.embed_mixins.any? && !options.embed_mixins_match?(superclass)

      [:class, :instance].each do |scope|
        superclass.attributes[scope].each do |_name, rw|
          sublist = [rw[:read], rw[:write]]
            .compact
            .reject { |el| !(::YARD::CodeObjects::Proxy === el.namespace) && el.is_alias? }

          list << sublist.first
        end
      end

      break if options.embed_mixins.empty?
    end

    list
      .sort_by { |el| [el.scope.to_s, el.name.to_s.downcase] }
  end

  def self.get_inherited_attributes(object:, options:)
    list = {}

    object.inheritance_tree(true)[1..-1].each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if !options.embed_mixins.empty? && options.embed_mixins_match?(superclass) != false

      sublist = superclass
        .attributes[:instance]
        .select  { |name, _rw| !object.child(scope: :instance, name: name) }
        .sort_by { |args| args.first.to_s }
        .map     { |_n, m| m[:read] || m[:write] }

      list[superclass.name] = { superclass: superclass, list: sublist }
    end

    list
  end


  # Constants ------------------------------------------------------------------

  def self.get_constants(object:, options:, include_inherited: false)
    list = object.meths(
      inherited: include_inherited,
      included:  options.embed_mixins.any?,
    )
    list = list + object.cvars

    list
      .sort_by { |el| [el.scope.to_s, el.name.to_s.downcase] }
  end

  def self.get_inherited_constants(object:, options:)
    list = {}

    object.inheritance_tree(true)[1..-1].each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if !options.embed_mixins.empty? && options.embed_mixins_match?(superclass) != false

      sublist = superclass.constants(included: false, inherited: false)
        .select  { |el| el.child(type: :constant, name: el.name).nil? }
        .sort_by { |el| el.name.to_s }

      list[superclass.name] = { superclass: superclass, list: sublist }
    end

    list
  end

end