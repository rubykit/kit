require_relative '../mixins/class_include1.rb'
require_relative '../mixins/class_extend1.rb'

# Defines a BaseNode
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
#  Mauris laoreet euismod velit, in malesuada diam rutrum in.
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
  # ```console
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
  # ```console
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
  # ```console
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
  # ```console
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
  # ```console
  # irb> node.instance_m1a(:replace, { layer: 2 })
  # [:ok]
  # ```
  #
  def self.class_m1a(next:, prev:)
    [:ok]
  end

end