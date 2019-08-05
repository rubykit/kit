module Kit::Domain::Models::Concerns
  module ReadRecord
    extend ActiveSupport::Concern

    included do
      self.abstract_class = true

      before_destroy { |record| raise ReadOnlyRecord }
    end

    def self.to_read_class
      self
    end

    def self.to_write_class
      self.name.gsub('::Read::', '::Write::').constantize rescue nil
    end

    def self.is_read_class?
      true
    end

    def self.is_write_class?
      false
    end

    def to_write_record
      self.class.to_write_class&.find_by(id: self.id)
    end

    def to_read_record
      self
    end

  end
end