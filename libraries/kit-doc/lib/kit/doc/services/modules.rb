# Logic used in `Yard` to retrieve objects or properties, centralized in one place.
module Kit::Doc::Services::Modules

  # Namespaces (modules + classes) ---------------------------------------------

  # Get all Classes & Modules as an array.
  def self.get_all_namespaces_as_list(options:, verifier_runner:)
    list = ::YARD::Registry.all(:class, :module)
    list = verifier_runner.call(list)

    list.delete_if { |el| el.has_tag?(:doc) && el.tag(:doc).text == 'false' }

    list
  end

  # Get all Classes & Modules as a hash, the key being the fully qualified name of the object.
  def self.get_all_namespaces_as_hash(options:, verifier_runner:)
    get_all_namespaces_as_list(options: options, verifier_runner: verifier_runner)
      .map { |el| ["#{ el.namespace.path.size > 0 ? "#{ el.namespace.path }::" : '' }#{ el.name }", el] }
      .sort_by { |name, _el| name }
  end

  # Modules --------------------------------------------------------------------

  # Get all Modules.
  #
  # ### References
  # - https://github.com/lsegal/yard/blob/master/templates/default/module/setup.rb#L19
  #
  def self.get_object_modules(object:, options:, verifier_runner:)
    list = object.children
      .select  { |el| el.type == :module }
      .sort_by { |el| el.name.to_s }

    list = verifier_runner.call(list)

    list
  end

  # Get the class / modules that have been included into `object`.
  def self.get_object_mixins_include(object:, verifier_runner:, **)
    list = object.mixins(:instance)

    list = verifier_runner.call(list)

    list.sort_by(&:path)
  end

  # Get the class / modules that have been extended into `object`.
  def self.get_object_mixins_extend(object:, verifier_runner:, **)
    list = object.mixins(:class)

    list = verifier_runner.call(list)

    list.sort_by(&:path)
  end

  # Get the class / modules that have included `object`.
  #
  # ### References
  # - https://github.com/lsegal/yard/blob/master/templates/default/module/setup.rb#L159
  #
  def self.get_object_included_into(object:, verifier_runner:, globals:, **)
    if !globals.mixins_included_into
      globals.mixins_included_into = {}

      list = ::YARD::Registry.all(:class, :module)
      list = verifier_runner.call(list)

      list.each do |o|
        o.mixins(:instance).each do |m|
          globals.mixins_included_into[m.path] ||= []
          globals.mixins_included_into[m.path] << o
        end
      end
    end

    (globals.mixins_included_into[object.path] || [])
      .sort_by(&:path)
  end

  # Get the class / modules that have extended `object`.
  #
  # ### References
  # - https://github.com/lsegal/yard/blob/master/templates/default/module/setup.rb#L159
  #
  def self.get_object_extended_into(object:, verifier_runner:, globals:, **)
    if !globals.mixins_extended_into
      globals.mixins_extended_into = {}

      list = ::YARD::Registry.all(:class, :module)
      list = verifier_runner.call(list)

      list.each do |o|
        o.mixins(:class).each do |m|
          globals.mixins_extended_into[m.path] ||= []
          globals.mixins_extended_into[m.path] << o
        end
      end
    end

    (globals.mixins_extended_into[object.path] || [])
      .sort_by(&:path)
  end

  # Classes --------------------------------------------------------------------

  # Get all classes declared in `object` namespace.
  #
  # ### References
  # - https://github.com/lsegal/yard/blob/master/templates/default/module/setup.rb#L19
  #
  def self.get_object_classes(object:, options:, verifier_runner:)
    list = object.children
      .select  { |el| el.type == :class }
      .sort_by { |el| el.name.to_s }

    list = verifier_runner.call(list)

    list
  end

  # Get all subclasses of `object`.
  #
  # ### References
  # - https://github.com/lsegal/yard/blob/master/templates/default/class/setup.rb#L18
  def self.get_object_subclasses(object:, options:, verifier_runner:, globals:)
    return [] if object.path == 'Object' # don't show subclasses for Object

    if !globals.subclasses
      globals.subclasses = {}
      global_list = verifier_runner.call(::YARD::Registry.all(:class))
      global_list.each do |o|
        (globals.subclasses[o.superclass.path] ||= []) << o if o.superclass
      end
    end

    subclasses = globals.subclasses[object.path] || []
    return [] if subclasses.size == 0

    list = subclasses
      .sort_by(&:path)

    list
  end

  # Methods --------------------------------------------------------------------

  # Get all methods of `object` as an array.
  def self.get_all_methods_as_list(options:, verifier_runner:)
    list = ::YARD::Registry.all(:method)
    list = verifier_runner.call(list)

    list.delete_if { |el| el.has_tag?(:doc) && el.tag(:doc).text == 'false' }

    list
  end

  # Get all methods of `object` as an hash.
  def self.get_object_methods(object:, options:, verifier_runner:, include_aliases: true, include_attributes: false, include_inherited: false, include_specials: true, include_instance_methods: true, include_class_methods: true)
    list = object.meths(
      inherited: include_inherited,
      included:  !options.embed_mixins.any?,
    )

    list = verifier_runner.call(list)

    if !include_aliases
      list.delete_if { |el| !(::YARD::CodeObjects::Proxy === el.namespace) && el.is_alias? } # rubocop:disable Style/CaseEquality
    end

    if !include_attributes
      list.delete_if { |el| !(::YARD::CodeObjects::Proxy === el.namespace) && el.is_attribute? } # rubocop:disable Style/CaseEquality
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

    list.delete_if { |el| el.has_tag?(:doc) && el.tag(:doc).text == 'false' }

    list
      .sort_by { |el| [el.scope.to_s, el.name.to_s.downcase] }
  end

  # Get all methods inherited by `object`.
  def self.get_object_inherited_methods(object:, options:, verifier_runner:, include_instance_methods: true, include_class_methods: true, hide_if_overwritten: true)
    list         = {}
    method_names = {}

    (object.inheritance_tree(true)[1..] || []).each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if options.embed_mixins.size > 0 && options.embed_mixins_match?(superclass) != false

      sublist = superclass
        .meths(included: false, inherited: false)
        .delete_if { |el| object.child(scope: el.scope, name: el.name) != nil }
        .delete_if { |el| el.is_alias? || el.is_attribute? }

      sublist = verifier_runner.call(sublist)

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

      sublist.delete_if { |el| el.has_tag?(:doc) && el.tag(:doc).text == 'false' }

      next if sublist.size == 0

      list[superclass.name] = { superclass: superclass, list: sublist }
    end

    list
  end

  # Attributes -----------------------------------------------------------------

  # Get all attributes of `object`.
  def self.get_object_attributes(object:, options:, verifier_runner:)
    list = []

    object.inheritance_tree(true).each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if options.embed_mixins.any? && !options.embed_mixins_match?(superclass)

      [:class, :instance].each do |scope|
        superclass.attributes[scope].each do |_name, rw|
          sublist = [rw[:read], rw[:write]]
            .compact
            .delete_if { |el| !(::YARD::CodeObjects::Proxy === el.namespace) && el.is_alias? } # rubocop:disable Style/CaseEquality

          sublist = verifier_runner.call(sublist)

          list << sublist.first
        end
      end

      break if options.embed_mixins.empty?
    end

    list
      .sort_by { |el| [el.scope.to_s, el.name.to_s.downcase] }
  end

  # Get all attributes inherited by `object`.
  def self.get_object_inherited_attributes(object:, options:, verifier_runner:)
    list = {}

    (object.inheritance_tree(true)[1..] || []).each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if !options.embed_mixins.empty? && options.embed_mixins_match?(superclass) != false

      sublist = superclass
        .attributes[:instance]
        .select  { |name, _rw| !object.child(scope: :instance, name: name) }
        .sort_by { |args| args.first.to_s }
        .map     { |_n, m| m[:read] || m[:write] }

      sublist = verifier_runner.call(sublist)

      list[superclass.name] = { superclass: superclass, list: sublist }
    end

    list
  end

  # Constants ------------------------------------------------------------------

  # Get all constants declared in `object` namespace as an array.
  def self.get_all_constants_as_list(options:, verifier_runner:)
    list = ::YARD::Registry.all(:constant)
    list = verifier_runner.call(list)

    list.delete_if { |el| el.has_tag?(:doc) && el.tag(:doc).text == 'false' }

    list
  end

  # Get all constants declared in `object` namespace as a hash.
  def self.get_object_constants(object:, options:, verifier_runner:, include_inherited: false)
    list = object.constants(
      inherited: include_inherited,
      included:  options.embed_mixins.any?,
    )
    list = (list + object.cvars)

    list = verifier_runner.call(list)

    list.delete_if { |el| el.has_tag?(:doc) && el.tag(:doc).text == 'false' }

    list
      .sort_by { |el| el.name.to_s }
  end

  # Get all constants declared in parent's `object` namespace.
  def self.get_object_inherited_constants(object:, options:, verifier_runner:)
    list = {}

    (object.inheritance_tree(true)[1..] || []).each do |superclass|
      next if superclass.is_a?(::YARD::CodeObjects::Proxy)
      next if !options.embed_mixins.empty? && options.embed_mixins_match?(superclass) != false

      sublist = superclass
        .constants(included: false, inherited: false)
        .select  { |el| object.child(type: :constant, name: el.name) == nil }
        .sort_by { |el| el.name.to_s }

      sublist = verifier_runner.call(sublist)

      sublist.delete_if { |el| el.has_tag?(:doc) && el.tag(:doc).text == 'false' }

      list[superclass.name] = { superclass: superclass, list: sublist }
    end

    list
  end

end
