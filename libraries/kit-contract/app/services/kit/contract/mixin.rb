require 'active_support/concern'

# Mixin that add `after`, `before`, `contract` class methods to enforce contracts on method signature.
module Kit::Contract::Mixin

  extend ::ActiveSupport::Concern

  included do |_base|
    self.reset_tmp_contracts
  end

  class_methods do

    def inherited(child_class) # rubocop:disable Lint/MissingSuper
      return if !Kit::Contract::Services::Runtime.active?

      child_class.reset_tmp_contracts
    end

    # TODO: add contracts INSIDE method body
    # contract Or[Callable, Array.of(Callable)]
    def before(arg)
      #Kit::Contract::Runtime.run_contracts
      return true if !Kit::Contract::Services::Runtime.active?

      self.tmp_contracts[:before].concat(arg.is_a?(::Array) ? arg : [arg])
      true
    end

    # contract Or[Callable, Array.of(Callable)]
    def after(arg)
      return true if !Kit::Contract::Services::Runtime.active?

      self.tmp_contracts[:after].concat(arg.is_a?(::Array) ? arg : [arg])
      true
    end

    # TODO: delay the exception to the method definition
    # contract Or[Hash.every_key(Callable).every_value(Callable).size(1), Callable]
    def contract(arg)
      return true if !Kit::Contract::Services::Runtime.active?

      if arg.respond_to?(:call)
        before(arg)
      elsif arg.is_a?(::Hash) && arg.size == 1
        before_contract, after_contract = arg.first
        before before_contract
        after  after_contract
      else
        raise 'Invalid use'
      end

      true
    end

    def contracts(args)
      return true if !Kit::Contract::Services::Runtime.active?

      before(args[:before]) if args[:before]
      after(args[:after])   if args[:after]
      true
    end

    protected

    attr_accessor :tmp_contracts

    def singleton_method_added(method_name)
      super
      declare_contracts(method_name: method_name, method_type: :singleton_method)
      true
    end

    def method_added(method_name)
      super
      declare_contracts(method_name: method_name, method_type: :method)
      true
    end

    def declare_contracts(method_name:, method_type:)
      Kit::Contract::Services::MethodWrapper.wrap(
        method_name:      method_name,
        method_type:      method_type,
        class_self:       self,
        contracts_before: self.tmp_contracts[:before],
        contracts_after:  self.tmp_contracts[:after],
      )

      reset_tmp_contracts
      true
    end

    def reset_tmp_contracts
      self.tmp_contracts = { after: [], before: [] }
    end

  end

end
