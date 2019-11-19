require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Eq do

  let(:contract) { described_class[1] }
  let(:args_valid) do
    [
      [1],
    ]
  end
  let(:args_invalid) do
    {
      ['1']        => 'EQ failed: expected `1`, got `1`',
      [2]          => 'EQ failed: expected `1`, got `2`',
      [{ c: :ok }] => 'EQ failed: expected `1`, got `{:c=>:ok}`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
