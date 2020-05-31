# Namespace for various Concerns.
module Kit::Domain::Models::Concerns
end

# Mixin for Record intended to have write access.
module Kit::Domain::Models::Concerns::WriteRecord

  extend ActiveSupport::Concern

  included do
    self.abstract_class = true
  end

  class_methods do

    def to_read_class
      self.name.gsub('::Write::', '::Read::').constantize
    rescue StandardError
      nil
    end

    def to_write_class
      self
    end

    def read_class?
      false
    end

    def write_class?
      true
    end

  end

  def to_read_record
    self.class.to_read_class&.find_by(id: self.id)
  end

  def to_write_record
    self
  end

end
