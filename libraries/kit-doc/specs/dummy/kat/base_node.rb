require_relative '../mixins/class_include1.rb'
require_relative '../mixins/class_extend1.rb'

# Defines a `BaseNode`.
#
# ## Linking
#
# Linking, the `Kit::Doc` (markdown) way:
#   - Current class: `Kat::BaseNode`
#   - Class method: `Kat::BaseNode.class_m`
#   - Instance method: `Kat::BaseNode#instance_m`
#   - External class: `Kat::ChildNode`
#   - Class method: `Kat::ChildNode.class_m`
#   - Instance method: `Kat::ChildNode#instance_m`
#   - Guide: [Ab colla deus](../docs/guides/ab_colla_deus.md)
#
# Linking, the {::YARD} way:
#   - Current class: {Kat::BaseNode}
#   - Class method: {.class_m}
#   - Instance method: {instance_m}
#   - External class: {Kat::ChildNode}
#   - Class method: {Kat::ChildNode.class_m}
#   - Instance method: {Kat::ChildNode#instance_m}
#   - Guide: {file:docs/guides/ab_colla_deus.md Ab colla deus}
#
# ## Random doc
#
# Overall, the node has three responsibilities:
#
#   * to provide eros eros, ultrices vitae nisi nec, placerat dapibus mi
#
#   * to define dictum ex maximus leo pretium faucibus
#
#   * to host quis suscipit dolor, ullamcorper commodo libero
#
# ## Usage
#
# A node is simply duis sed augue sed ipsum rhoncus imperdiet. Interdum et
# malesuada fames ac ante ipsum primis in faucibus. Etiam non nisl leo.
# Vestibulum molestie nisl felis, a vulputate purus ultricies at:
#
# ```ruby
# node = BaseNode.new(options: { active: false })
#
# node.instance_m(:substitute) do |el|
#   # code ...
#   # code ...
# end
# ```
#
# Mauris laoreet euismod velit, in malesuada diam rutrum in.
class Kat::BaseNode

  include ClassInclude1
  extend  ClassExtend1

  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  attr_reader :attr1

  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  BASE_CONST = 2

  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  #
  # ## Examples
  #
  # ```irb
  # irb> node.instance_m1a(:replace, { layer: 2 })
  # [:ok]
  # ```
  #
  def initialize(options:)
  end

  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  #
  # ## Examples
  #
  # ```irb
  # irb> node.instance_m(:replace, { layer: 2 })
  # [:ok]
  # ```
  #
  def instance_m(action, options = {}, &block)
    [:ok]
  end

  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  #
  # ## Examples
  #
  # ```irb
  # irb> BaseNode.class_m(next: true, prev: false)
  # [:ok]
  # ```
  #
  def self.class_m(next:, prev:)
    [:ok]
  end

  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  #
  # ## Examples
  #
  # ```irb
  # irb> node.instance_m1a(:replace, { layer: 2 })
  # [:ok]
  # ```
  #
  def instance_m1a(action, options = {}, &block)
    [:ok]
  end

  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  #
  # ## Examples
  #
  # ```irb
  # irb> node.instance_m1a(:replace, { layer: 2 })
  # [:ok]
  # ```
  #
  def self.class_m1a(next:, prev:)
    [:ok]
  end

end