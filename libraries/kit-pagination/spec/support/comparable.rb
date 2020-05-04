# https://bugs.ruby-lang.org/issues/12648

module Comparable
  class SortableTuple < Array
    include Comparable

    attr_reader :orderings

    def initialize(orderings)
      # Adding keyword options like `allow_nil` (`:first`/`:last`) would be great.
      replace orderings.map { |key, dir|
        desc =
          case dir
          when :desc
            true
          when :asc
            false
          else
            raise ArgumentError, "direction must be either :asc or :desc: #{dir.inspect}"
          end
        [key, desc]
      }
    end

    def <=>(other)
      if other.instance_of?(self.class)
        other.each_with_index { |(b, desc), i|
          a, = self[i]
          case cmp = a <=> b
          when Integer
            return desc ? -cmp : cmp unless cmp.zero?
          else
            return cmp
          end
        }
      end
    end
  end

  def self.[](*args)
    SortableTuple.new(*args)
  end
end