module Kit::Auth::Models
  class WriteRecord < ApplicationRecord
    self.abstract_class = true

    establish_connection :"#{Rails.env}_write"
  end
end
