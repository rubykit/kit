require_relative 'rails_helper'
require_relative '../lib/kit/contract'
require_relative 'shared/signature_exemples'

module TestModule
  include Kit::Contract

  after ->(v) { v > 0 }
  after ->(v) { v < 10 }
  def self.test_after_multiple_contracts(value:)
    value
  end

  after [
    ->(v) { v > 0 },
    ->(v) { v < 10 },
  ]
  def self.test_after_multiple_contracts_array(value:)
    value
  end

end

describe "before" do

  context 'with multiple single contracts' do
    subject { TestModule.method(:test_after_multiple_contracts) }

    let(:args_valid) do
      {
        [{ value: 2,  }] => 2,
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [{ value: 0, }] => "Contract failure after `TestModule#test_after_multiple_contracts`",
        [{ value: 10, }] => "Contract failure after `TestModule#test_after_multiple_contracts`",
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

  context 'with multiple contracts as an array' do
    subject { TestModule.method(:test_after_multiple_contracts_array) }

    let(:args_valid) do
      {
        [{ value: 2 }] => 2,
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [{ value: 0,  }] => "Contract failure after `TestModule#test_after_multiple_contracts_array`",
        [{ value: 10, }] => "Contract failure after `TestModule#test_after_multiple_contracts_array`",
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

end
