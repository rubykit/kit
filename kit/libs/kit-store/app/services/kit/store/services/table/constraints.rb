imodule Kit::Store::Services::Table
  module Constraints
    extend T::Sig

    def self.run(table:, data_array:)
      [:ok]
    end

  end
end