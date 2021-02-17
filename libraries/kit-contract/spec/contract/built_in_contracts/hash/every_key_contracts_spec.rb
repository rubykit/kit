require_relative '../../../rails_helper'
require_relative '../../shared/types_exemples'
require_relative '../../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Hash do

  context 'with every key contracts' do
    always_true = ->(*) { true }
    callable    = ->(k) { k.is_a?(::Symbol) }
    contracts   = [
      described_class.every_key(callable),
      described_class.of(callable => always_true),
    ]

    let(:args_valid) do
      [
        { kwargs: { a: :symbol } },
        { kwargs: { c: 2.0, f: -> {} } },
      ]
    end

    let(:args_invalid) do
      {
        { kwargs:{ 'str' => :b } }       => 'Invalid result type for contract',
        { kwargs:{ :a => 2, 'b' => 2 } } => 'Invalid result type for contract',
        { kwargs:{ 2 => :c } }           => 'Invalid result type for contract',
      }
    end

    contracts.each do |contract|
      it_behaves_like 'a contract that succeeds on valid values', contract
      it_behaves_like 'a contract that fails on invalid values',  contract
    end
  end

end
