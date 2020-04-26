require_relative 'child_node'

# Defines a ChildChildNode
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
#     node = ChildChildNode.new(options: { active: false })
#
#     node.instance_m(:substitute) do |el|
#       # code ...
#       # code ...
#     end
#
#  Mauris laoreet euismod velit, in malesuada diam rutrum in.
class Kat::ChildChildNode < Kat::ChildNode

  # Maecenas a imperdiet mauris.
  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  attr_reader :attr3

  # Maecenas a imperdiet mauris.
  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  CHILD_CONST = 3

  # Maecenas a imperdiet mauris.
  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  CHILD_CHILD_CONST = 3

  # Maecenas a imperdiet mauris.
  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  def instance_m3(x:, y:, z:)
  end

  # Maecenas a imperdiet mauris.
  # Etiam luctus est tellus, nec aliquam mi maximus in.
  # Sed fermentum imperdiet turpis sit amet dapibus.
  def self.class_m3(u, v, w:)
  end

end


require_relative 'base_node'

# Defines a ChildNode
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
#     node = BaseNode.new(options: { active: false })
#
#     node.instance_m2(:substitute) do |el|
#       # code ...
#       # code ...
#     end
#
#  Mauris laoreet euismod velit, in malesuada diam rutrum in.
class Kat::ChildNode < Kat::BaseNode

  # In ut ligula vel arcu finibus euismod ut eget mi.
  # Suspendisse ac mauris id mi maximus dictum.
  attr_reader :attr3

  # In ut ligula vel arcu finibus euismod ut eget mi.
  # Suspendisse ac mauris id mi maximus dictum.
  CHILD_CONST = 3

  # In ut ligula vel arcu finibus euismod ut eget mi.
  # Suspendisse ac mauris id mi maximus dictum.
  CHILD_CHILD_CONST = 3

  # In ut ligula vel arcu finibus euismod ut eget mi.
  # Suspendisse ac mauris id mi maximus dictum.
  #
  # ## Examples
  #
  #     irb> node.instance_m(:replace, { layer: 2 })
  #     [:ok]
  def instance_m(action, options = {}, &block)
    [:ok]
  end

  # In ut ligula vel arcu finibus euismod ut eget mi.
  # Suspendisse ac mauris id mi maximus dictum.
  #
  # ## Examples
  #
  #     irb> ChildNode.class_m(next: true, prev: false)
  #     [:ok]
  def self.class_m(next:, prev:)
    [:ok]
  end

  # In ut ligula vel arcu finibus euismod ut eget mi.
  # Suspendisse ac mauris id mi maximus dictum.
  #
  # ## Examples
  #
  #     irb> node.instance_m3(:replace, { layer: 2 })
  #     [:ok]
  def instance_m3(action, options = {}, &block)
    [:ok]
  end

  # In ut ligula vel arcu finibus euismod ut eget mi.
  # Suspendisse ac mauris id mi maximus dictum.
  #
  # ## Examples
  #
  #     irb> ChildChildNode.class_m3(next: true, prev: false)
  #     [:ok]
  def self.class_m3(next:, prev:)
    [:ok]
  end

end