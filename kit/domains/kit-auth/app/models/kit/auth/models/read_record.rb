module Kit::Auth::Models
  class ReadRecord < EngineRecord
    self.abstract_class = true

    establish_connection :"#{Rails.env}_readonly"

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

    before_destroy { |record| raise ReadOnlyRecord }
  end
end
