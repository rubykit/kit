require_relative '../../../rails_helper'
require_relative '../../shared/types_exemples'
require_relative '../../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Array do

  context 'with every key contracts' do
    contract0 = ->(v) { v.is_a?(Symbol) }
    contract1 = ->(v) { v == 3 }

    contracts = [
      described_class[contract0, contract1],
      described_class.with([contract0, contract1]),
      described_class.at(0 => contract0, 1 => contract1),
    ]

    let(:args_valid) do
      [
        { args: [[:a, 3]] },
        { args: [[:b, 3, :c]] },
      ]
    end

    let(:args_invalid) do
      {
        { args: [[:a, 2]] }      => 'Invalid result type for contract',
        { args: [['a', 3]] }     => 'Invalid result type for contract',
        { args: [[:b, 2, :c]] }  => 'Invalid result type for contract',
        { args: [['b', 3, :c]] } => 'Invalid result type for contract',
      }
    end

    contracts.each do |contract|
      it_behaves_like 'a contract that succeeds on valid values', contract
      it_behaves_like 'a contract that fails on invalid values',  contract
    end
  end

end
