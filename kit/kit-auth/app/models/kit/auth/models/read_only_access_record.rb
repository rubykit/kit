module Kit::Auth::Models
  class ReadOnlyAccessRecord < ApplicationRecord
    self.abstract_class = true

    establish_connection :"#{Rails.env}_readonly"

    def readonly?
      true
    end

    before_destroy { |record| raise ReadOnlyRecord }
  end
end
