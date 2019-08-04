module Kit::Auth::Models
  class EngineRecord < ApplicationRecord
    self.abstract_class = true

    class_attribute :columns_whitelisting
    self.columns_whitelisting = true

    def self.table_name
      name.demodulize.tableize
    end

    # Ex: User#1
    def model_log_name
      "#{self.class.model_name.element.camelize}##{self.id}"
    end

    # Ex: User#1|dev@test.com
    def model_verbose_name
      "#{self.class.model_name.element.camelize}##{self.id}"
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

  end
end
