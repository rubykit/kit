module Kit::Auth::Models
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def self.table_name
      name.demodulize.tableize
    end
  end
end
