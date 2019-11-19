require_relative '../../../rails_helper'
require_relative '../../shared/types_exemples'
require_relative '../../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Hash do

  context 'with targetted keys contracts' do
    callable  = ->(v) { v.is_a?(::Symbol) }
    contracts = [
      described_class[a: callable],
      described_class.with(a: callable),
    ]

    let(:args_valid) do
      [
        [{ a: :symbol, }],
        [{ a: :symbol, b: 2, }],
      ]
    end
    let(:args_invalid) do
      {
        [{ a: 2, }]       => 'Invalid result type for contract',
        [{ a: 2, b: 2, }] => 'Invalid result type for contract',
      }
    end

    contracts.each do |contract|
      it_behaves_like 'a contract that succeeds on valid values', contract
      it_behaves_like 'a contract that fails on invalid values', contract
    end
  end

end
