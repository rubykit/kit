require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Optional do

  let(:contract) { described_class[->(el) { el.is_a?(Hash) }] }

  let(:args_valid) do
    [
      { args: [] },
      { args: [nil] },
      { args: [{ a: 1 }] },
    ]
  end

  let(:args_invalid) do
    {
      { args: [2] }   => 'Invalid result type for contract',
      { args: [[2]] } => 'Invalid result type for contract',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
