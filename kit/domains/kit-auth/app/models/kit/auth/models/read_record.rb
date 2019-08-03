module Kit::Auth::Models
  class ReadRecord < ApplicationRecord
    self.abstract_class = true

    establish_connection :"#{Rails.env}_readonly"

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

    def is_read_record?
      self.class.is_read_class?
    end

    def is_write_record?
      self.class.is_write_class?
    end

    def readonly?
      self.class.is_read_class?
    end

    before_destroy { |record| raise ReadOnlyRecord }
  end
end
