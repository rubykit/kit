require_relative '../../rails_helper'
require_relative '../shared/signature_exemples'
require_relative '../../../lib/kit/contract'

# Namespace for test dummy modules.
module TestModules
end

# Dummy module.
module TestModules::ArrayTests

  include Kit::Contract
  Ct = Kit::Contract::BuiltInContracts

  contract Ct::Array[Ct::Integer, Ct::Integer]
  def self.method_array(a) # rubocop:disable Naming/MethodParameterName
    [:ok]
  end

  contract Ct::Args[Ct::Integer, Ct::Integer]
  def self.method_args(a, b) # rubocop:disable Naming/MethodParameterName
    [:ok]
  end

end

describe ::Kit::Contract::BuiltInContracts::Array do

  context 'for a signature contract that expects a single array' do
    subject { TestModules::ArrayTests.method(:method_array) }

    let(:args_valid) do
      {
        [[1, 2]] => [:ok],
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [1, 2] => [ArgumentError, 'wrong number of arguments (given 2, expected 1)'],
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

  context 'for a signature contract that expects a list or aguments' do
    subject { TestModules::ArrayTests.method(:method_args) }

    let(:args_valid) do
      {
        [1, 2] => [:ok],
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [[1, 2]] => [ArgumentError, 'wrong number of arguments (given 1, expected 2)'],
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

end
