require_relative '../../../rails_helper'
require_relative '../../shared/types_exemples'
require_relative '../../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Hash do

  context 'with instance contracts' do
    contracts = [
      described_class.instance(->(i) { i.size == 2 }),
      described_class.size(2),
    ]

    let(:args_valid) do
      [
        { args: [{ a: :symbol, b: 2 }] },
        { args: [{ c: 2.0, f: -> {} }] },
      ]
    end

    let(:args_invalid) do
      {
        { args: [{ a: 2 }] }   => 'Invalid result type for contract',
        { args: [{ c: 2.0 }] } => 'Invalid result type for contract',
      }
    end

    contracts.each do |contract|
      it_behaves_like 'a contract that succeeds on valid values', contract
      it_behaves_like 'a contract that fails on invalid values',  contract
    end
  end

end
