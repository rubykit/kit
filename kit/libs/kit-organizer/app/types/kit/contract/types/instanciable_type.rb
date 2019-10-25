module Kit::Contract::Types

  class InstanciableType
    def self.[](*contracts)
      new(*contracts)
    end

    def call
      raise "Implement me!"
    end
  end

end