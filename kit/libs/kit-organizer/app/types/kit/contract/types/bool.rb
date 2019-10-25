module Kit::Contract::Types

  # Bool = Or[IsA[::TrueClass], IsA[FalseClass]]

  class Bool
    def self.call(value)
      if value == true || value == false
        [:ok]
      else
        [:error, "Value `#{value}` is not a Boolean"]
      end
    end
  end

end