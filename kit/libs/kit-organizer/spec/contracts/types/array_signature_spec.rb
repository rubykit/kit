require_relative '../../rails_helper'
require_relative '../shared/signature_exemples'
require_relative '../../../lib/kit/contract'

module TestClasses
  module ArrayTests
    include Kit::Contract
    include Kit::Contract::Types

    contract Array[Integer, Integer]
    def self.method_array(a)
      [:ok]
    end

    contract Args[Integer, Integer]
    def self.method_args(a, b)
      [:ok]
    end

  end
end


describe ::Kit::Contract::Types::Array do

  context 'for a signature contract that expects a single array' do
    subject { TestClasses::ArrayTests.method(:method_array) }

    let(:args_valid) do
      {
        [[1, 2]] => [:ok],
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [1, 2] => [ArgumentError, "wrong number of arguments (given 2, expected 1)"],
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

  context 'for a signature contract that expects a list or aguments' do
    subject { TestClasses::ArrayTests.method(:method_args) }

    let(:args_valid) do
      {
        [1, 2] => [:ok],
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [[1, 2]] => [ArgumentError, "wrong number of arguments (given 1, expected 2)"],
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

end
