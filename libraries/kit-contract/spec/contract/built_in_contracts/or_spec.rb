require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Or do

  let(:contract) do
    described_class[
      ->(v) { v == 1 },
      ->(v) { v == '1' },
    ]
  end
  let(:args_valid) do
    [
      { args: [1] },
      { args: ['1'] },
    ]
  end
  let(:args_invalid) do
    {
      { args: [nil] }        => 'OR failed',
      { args: [2] }          => 'OR failed',
      { args: [{ c: :ok }] } => 'OR failed',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
