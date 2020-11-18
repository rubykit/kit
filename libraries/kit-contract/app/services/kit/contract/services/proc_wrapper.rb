module Kit::Contract::Services::ProcWrapper
=begin

  # 3 types of check:
  #  - callable CAN receive specified payload
  #  - correct payload is sent when called         < SHOULD BE IN THE CONTRACT, NOT TIED TO THE CALLABLE ?
  #  - correct return is received when called      < SHOULD BE IN THE CONTRACT, NOT TIED TO THE CALLABLE ?

  # Why not go through the store ? Highly context dependant.
  #  >> The same proc can be used through different  contracts in different contexts.

  class KitProc < ::Proc
    def add_kit_contracts(contracts:)
      self.class.add_kit_contracts(contracts: contracts)
    end

    def run_kit_contracts
      self.class.run_kit_contracts
    end

    class << self
      def add_kit_contracts(contracts:)
        self.kit_contracts ||= []
        self.kit_contracts.concat(contracts.is_a?(::Array) ? contracts : [contracts])
      end

      def run_kit_contracts
        self.kit_contracts ||= []
        puts "RUN CONTRACTS CALLED - #{self.kit_contracts.count} contracts"
      end

      protected

      attr_accessor :kit_contracts
    end
  end

  def self.add_contracts(callable:, contracts:)
    if !callable.is_a?(KitProc)
      callable = wrap_proc(callable: callable)
    else
      # REFLECT ABOUT THIS, this might be a terrible idea, new wrapped proc every time is probably simpler & safer.
      # We need to clone it before adding new contracts or we will have side effects
    end

    callable.add_kit_contracts(contracts: contracts)

    callable
  end

  def self.wrap_proc(callable:)
    original_callable = callable
    parameters        = callable.parameters
    signature_str     = Kit::Contract::Services::RubyHelpers.parameters_as_signature_to_s(parameters: parameters)
    args_str          = Kit::Contract::Services::RubyHelpers.parameters_as_array_to_s(parameters: parameters)

    wrapped_callable = eval %{
      new_callable = KitProc.new(&lambda do |#{signature_str}|
        new_callable.run_kit_contracts

        result = original_callable.call(*#{args_str})

        new_callable.run_kit_contracts

        result
      end)
    }, binding

    wrapped_callable
  end

=end
end
