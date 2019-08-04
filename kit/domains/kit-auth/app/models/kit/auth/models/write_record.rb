module Kit::Auth::Models
  class WriteRecord < EngineRecord
    self.abstract_class = true

    establish_connection :"#{Rails.env}_write"

    def self.to_read_class
      self.name.gsub('::Write::', '::Read::').constantize rescue nil
    end

    def self.to_write_class
      self
    end

    def self.is_read_class?
      false
    end

    def self.is_write_class?
      true
    end

    def to_read_record
      self.class.to_read_class&.find_by(id: self.id)
    end

    def to_write_record
      self
    end

  end
end
