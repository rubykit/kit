require_relative '../rails_helper'
require_relative '../../lib/kit/contract'
require_relative 'shared/signature_exemples'

# Namespace for test dummy modules.
module TestModules
end

# Dummy module.
module TestModules::Contract
  include Kit::Contract::Mixin

  contract((->(input) { input < 10 }) => (->(output) { output > 10 }))
  def self.test_contract_hash(input)
    input + 10
  end

  contract ->(input) { input < 10 }
  def self.test_contract_callable(input)
    input + 10
  end

end

describe 'contract' do

  context 'with a hash as a parameter' do
    subject { TestModules::Contract.method(:test_contract_hash) }

    let(:args_valid) do
      {
        { args: [5] } => 15,
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        { args: [15] } => 'Contract failure before `TestModules::Contract#test_contract_hash`',
        { args: [-5] } => 'Contract failure after `TestModules::Contract#test_contract_hash`',
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

  context 'with a callable as a parameter' do
    subject { TestModules::Contract.method(:test_contract_callable) }

    let(:args_valid) do
      {
        { args: [5] } => 15,
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        { args: [10] } => 'Contract failure before `TestModules::Contract#test_contract_callable`',
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

end
