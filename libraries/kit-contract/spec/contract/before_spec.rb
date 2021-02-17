require_relative '../rails_helper'
require_relative '../../lib/kit/contract'
require_relative 'shared/signature_exemples'

# Namespace for test dummy modules.
module TestModules
end

# Dummy module.
module TestModules::Before

  include Kit::Contract::Mixin

  before ->(value:) { value > 0 }
  before ->(value:) { value < 10 }
  def self.test_before_multiple_contracts(value:)
    [:ok]
  end

  before [
    ->(value:) { value > 0 },
    ->(value:) { value < 10 },
  ]
  def self.test_before_multiple_contracts_array(value:)
    [:ok]
  end

end

describe 'before' do

  context 'with multiple single contracts' do
    subject { TestModules::Before.method(:test_before_multiple_contracts) }

    let(:args_valid) do
      {
        { kwargs: { value: 2 } } => [:ok],
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        { kwargs: { value: 0 }  }  => 'Contract failure before `TestModules::Before#test_before_multiple_contracts`',
        { kwargs: { value: 10 } } => 'Contract failure before `TestModules::Before#test_before_multiple_contracts`',
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

  context 'with multiple single contracts' do
    subject { TestModules::Before.method(:test_before_multiple_contracts_array) }

    let(:args_valid) do
      {
        { kwargs: { value: 2 } } => [:ok],
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        { kwargs: { value: 0 } }  => 'Contract failure before `TestModules::Before#test_before_multiple_contracts_array`',
        { kwargs: { value: 10 } } => 'Contract failure before `TestModules::Before#test_before_multiple_contracts_array`',
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

end
