require_relative 'rails_helper'
require_relative '../lib/kit/contract'
require_relative 'shared/signature_exemples'

module TestModule
  include Kit::Contract

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

describe "before" do

  context 'with multiple single contracts' do
    subject { TestModule.method(:test_before_multiple_contracts) }

    let(:args_valid) do
      {
        [{ value: 2, }] => [:ok],
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [{ value: 0, }] => "Contract failure before `TestModule#test_before_multiple_contracts`",
        [{ value: 10, }] => "Contract failure before `TestModule#test_before_multiple_contracts`",
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

  context 'with multiple single contracts' do
    subject { TestModule.method(:test_before_multiple_contracts_array) }

    let(:args_valid) do
      {
        [{ value: 2 }] => [:ok],
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [{ value: 0, }] => "Contract failure before `TestModule#test_before_multiple_contracts_array`",
        [{ value: 10, }] => "Contract failure before `TestModule#test_before_multiple_contracts_array`",
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

end
