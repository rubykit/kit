module Yard::Kit::Services::Modules

  def self.get_modules_list(options:)
    # TODO: check if we should use `options.objects` instead

    list = ::YARD::Registry.all(:class, :module)
    #list = run_verifier(list)

    list.delete_if { |el| el.has_tag?(:api) && el.tag(:api).text == 'hide' }

    list
  end

  def self.get_modules_hash(options:)
    get_modules_list(options: options)
      .map { |el| ["#{ el.namespace.path.size > 0 ? "#{ el.namespace.path }::" : '' }#{ el.name }", el] }
      .sort_by { |name, el| name }
  end

  # Methods --------------------------------------------------------------------

  # @note Does not include `verifiers`
  def self.get_methods(object:, options:, include_aliases: true, include_attributes: false, include_inherited: false, include_specials: true, include_instance_methods: true, include_class_methods: true)
    list = object.meths(
      inherited: include_inherited,
      included:  !options.embed_mixins.any?,
    )

    if !include_aliases
      list.delete_if { |el| !(::YARD::CodeObjects::Proxy === el.namespace) && el.is_alias? }
    end

    if !include_attributes
      list.delete_if { |el| !(::YARD::CodeObjects::Proxy === el.namespace) && el.is_attribute? }
    end

    if !include_specials
      list.delete_if { |el| el.constructor? || el.name(true) == '#method_missing' }
    end

    if !include_instance_methods
      list.delete_if { |el| el.scope == :instance }
    end

    if !include_class_methods
      list.delete_if { |el| el.scope == :class }
    end

    if options.embed_mixins.any?
      list.delete_if { |el| options.embed_mixins_match?(el.namespace) == false }
    end

    list.delete_if { |el| el.has_tag?(:api) && el.tag(:api).text == 'hide' }

    list
      .sort_by { |el| [el.scope.to_s, el.name.to_s.downcase] }
  end

  def self.get_inherited_methods(object:, options:, include_instance_methods: true, include_class_methods: true, hide_if_overwritten: true)
    list         = {}
    method_names = {}

    (object.inheritance_tree(true)[1..-1] || []).each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if options.embed_mixins.size > 0 && options.embed_mixins_match?(superclass) != false

      sublist = superclass
        .meths(included: false, inherited: false)
        .delete_if { |el| object.child(scope: el.scope, name: el.name) != nil }
        .delete_if { |el| el.is_alias? || el.is_attribute? }

      if hide_if_overwritten
        sublist.delete_if { |el| method_names[el.name] == true }
        sublist.each { |el| method_names[el.name] = true }
      end

      if !include_instance_methods
        sublist.delete_if { |el| el.scope == :instance }
      end

      if !include_class_methods
        sublist.delete_if { |el| el.scope == :class }
      end

      sublist.delete_if { |el| el.has_tag?(:api) && el.tag(:api).text == 'hide' }

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
            .delete_if { |el| !(::YARD::CodeObjects::Proxy === el.namespace) && el.is_alias? }

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

    (object.inheritance_tree(true)[1..-1] || []).each do |superclass|
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
    list = object.constants(
      inherited: include_inherited,
      included:  options.embed_mixins.any?,
    )
    list = (list + object.cvars)

    list.delete_if { |el| el.has_tag?(:api) && el.tag(:api).text == 'hide' }

    list
      .sort_by { |el| el.name.to_s }
  end

  def self.get_inherited_constants(object:, options:)
    list = {}

    (object.inheritance_tree(true)[1..-1] || []).each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if !options.embed_mixins.empty? && options.embed_mixins_match?(superclass) != false

      sublist = superclass
        .constants(included: false, inherited: false)
        .select  { |el| object.child(type: :constant, name: el.name) == nil }
        .sort_by { |el| el.name.to_s }

      sublist.delete_if { |el| el.has_tag?(:api) && el.tag(:api).text == 'hide' }

      list[superclass.name] = { superclass: superclass, list: sublist }
    end

    list
  end

end