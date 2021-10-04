# Namespace for various Concerns.
module Kit::Domain::Models::Concerns
end

# Mixin for Record intended to only have read access.
module Kit::Domain::Models::Concerns::ReadRecord

  extend ActiveSupport::Concern

  included do
    self.abstract_class = true

    before_destroy { |_record| raise ReadOnlyRecord }
  end

  class_methods do

    def to_read_class
      self
    end

    def to_write_class
      self.name.gsub('::Read::', '::Write::').constantize
    rescue StandardError
      nil
    end

    def read_class?
      true
    end

    def write_class?
      false
    end

  end

  def to_write_record
    self.class.to_write_class&.find_by(id: self.id)
  end

  def to_read_record
    self
  end

  # Ex: User#1
  def model_log_name
    "#{ self.class.model_name.element.camelize }##{ self.id }"
  end

  # Ex: User#1|user@rubykit.org
  def model_verbose_name
    "#{ self.class.model_name.element.camelize }##{ self.id }"
  end

end
