require_relative '../../../rails_helper'
require_relative '../../shared/types_exemples'
require_relative '../../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Hash do

  context 'with key & value contracts' do
    let(:contract) { described_class.every(->(key, value) { key.is_a?(::Symbol) && value.is_a?(::Integer) && value > 10 }) }

    let(:args_valid) do
      [
        { args: [{ a: 11, b: 12 }] },
        { args: [{ key: 15 }] },
      ]
    end
    let(:args_invalid) do
      {
        { args: [{ a: 11, b: 5 }] }         => 'Invalid result type for contract',
        { args: [{ a: 11, b: '12' }] }      => 'Invalid result type for contract',
        { args: [{ :a => 11, 'b' => 12 }] } => 'Invalid result type for contract',
        { args: [{ key: 9 }] }              => 'Invalid result type for contract',
        { args: [{ key: 15.0 }] }           => 'Invalid result type for contract',
        { args: [{ 'key' => 15 }] }         => 'Invalid result type for contract',
      }
    end

    it_behaves_like 'a contract that succeeds on valid values'
    it_behaves_like 'a contract that fails on invalid values'
  end

end
