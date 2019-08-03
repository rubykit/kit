module Kit::Auth::Models
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

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

  end
end
