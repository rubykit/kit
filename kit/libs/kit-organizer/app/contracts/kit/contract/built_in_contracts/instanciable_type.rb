module Kit::Contract::BuiltInContracts

  class InstanciableType
    def self.[](*contracts)
      new(*contracts)
    end

    def call
      raise "Implement me!"
    end
  end

end