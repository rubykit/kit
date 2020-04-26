require_relative 'base_node'
require_relative '../mixins/class_include2.rb'
require_relative '../mixins/class_extend2.rb'

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
#     node = ChildNode.new(options: { active: false })
#
#     node.instance_m(:substitute) do |el|
#       # code ...
#       # code ...
#     end
#
#  Mauris laoreet euismod velit, in malesuada diam rutrum in.
class Kat::ChildNode < Kat::BaseNode

  include ClassInclude2
  extend  ClassExtend2

  # Donec ultricies, mauris quis fringilla vulputate, urna turpis tincidunt
  # nisl, non scelerisque libero ipsum eget eros.
  attr_reader :attr2

  # Donec ultricies, mauris quis fringilla vulputate, urna turpis tincidunt
  # nisl, non scelerisque libero ipsum eget eros.
  CHILD_CONST = 2

  # Donec ultricies, mauris quis fringilla vulputate, urna turpis tincidunt
  # nisl, non scelerisque libero ipsum eget eros.
  #
  # ## Examples
  #
  #     irb> ChildNode.new(options: { levels: 3 })
  #
  def initialize(options:)
  end

  # Donec ultricies, mauris quis fringilla vulputate, urna turpis tincidunt
  # nisl, non scelerisque libero ipsum eget eros.
  #
  # ## Examples
  #
  #     irb> node.instance_m(:replace, { layer: 2 })
  #     [:ok]
  def instance_m(action, options = {}, &block)
    [:ok]
  end

  # Donec ultricies, mauris quis fringilla vulputate, urna turpis tincidunt
  # nisl, non scelerisque libero ipsum eget eros.
  #
  # ## Examples
  #
  #     irb> ChildNode.class_m(next: true, prev: false)
  #     [:ok]
  def self.class_m(next:, prev:)
    [:ok]
  end

  # Donec ultricies, mauris quis fringilla vulputate, urna turpis tincidunt
  # nisl, non scelerisque libero ipsum eget eros.
  #
  # ## Examples
  #
  #     irb> node.instance_m2(:replace, { layer: 2 })
  #     [:ok]
  def instance_m2(action, options = {}, &block)
    [:ok]
  end

  # Donec ultricies, mauris quis fringilla vulputate, urna turpis tincidunt
  # nisl, non scelerisque libero ipsum eget eros.
  #
  # ## Examples
  #
  #     irb> ChildNode.class_m2(next: true, prev: false)
  #     [:ok]
  def self.class_m2(next:, prev:)
    [:ok]
  end

end
