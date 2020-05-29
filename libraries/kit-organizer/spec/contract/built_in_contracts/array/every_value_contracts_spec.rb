require_relative '../../../rails_helper'
require_relative '../../shared/types_exemples'
require_relative '../../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Array do

  context 'with every value contracts' do
    callable    = ->(v) { v.is_a?(::Symbol) }
    contracts   = [
      described_class.every(callable),
      described_class.of(callable),
    ]

    let(:args_valid) do
      [
        [[:a]],
        [[:a, :b]],
      ]
    end

    let(:args_invalid) do
      {
        [['a']]     => 'Invalid result type for contract',
        [[:a, 'b']] => 'Invalid result type for contract',
      }
    end

    contracts.each do |contract|
      it_behaves_like 'a contract that succeeds on valid values', contract
      it_behaves_like 'a contract that fails on invalid values',  contract
    end

  end

end
