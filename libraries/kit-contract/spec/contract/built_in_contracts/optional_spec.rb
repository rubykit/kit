require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Optional do

  let(:contract) { described_class[->(el) { el.is_a?(Hash) }] }

  let(:args_valid) do
    [
      [],
      [nil],
      [{ a: 1 }],
    ]
  end

  let(:args_invalid) do
    {
      [2]   => 'Invalid result type for contract',
      [[2]] => 'Invalid result type for contract',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
