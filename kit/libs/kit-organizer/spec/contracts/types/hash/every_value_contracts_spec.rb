require_relative '../../../rails_helper'
require_relative '../../shared/types_exemples'
require_relative '../../../../lib/kit/contract'

describe Kit::Contract::Types::Hash do

  context 'with every value contracts' do
    always_true = ->(*) { true }
    callable    = ->(v) { v.is_a?(::Symbol) }
    contracts   = [
      described_class.every_value(callable),
      described_class.of(always_true => callable),
    ]

    let(:args_valid) do
      [
        [{ a: :symbol, }],
        [{ 'str' => :b, }],
        [{ 2 => :c }],
      ]
    end

    let(:args_invalid) do
      {
        [{ c: 2.0, f: ->() {} }] => 'Invalid result type for contract',
        [{ :a => 2, 'b' => 2 }]  => 'Invalid result type for contract',
      }
    end

    contracts.each do |contract|
      it_behaves_like 'a contract that succeeds on valid values', contract
      it_behaves_like 'a contract that fails on invalid values',  contract
    end

  end

end