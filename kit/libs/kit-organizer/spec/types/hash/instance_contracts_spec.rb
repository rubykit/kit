require_relative '../../rails_helper'
require_relative '../../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::Types::Hash do

  context 'with instance contracts' do
    let(:contract) { described_class.instance(->(i) { i.size == 2 }) }

    let(:args_valid) do
      [
        [{ a: :symbol, b: 2, }],
        [{ c: 2.0, f: ->() {} }],
      ]
    end

    it_behaves_like 'a contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [{ a: 2, }]   => 'Invalid result type for contract',
        [{ c: 2.0, }] => 'Invalid result type for contract',
      }
    end

    it_behaves_like 'a contract that fails on invalid values'
  end

end