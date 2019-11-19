module Kit::Contract::BuiltInContracts

  class Any
    def self.call(value = nil)
      [:ok]
    end
  end

end