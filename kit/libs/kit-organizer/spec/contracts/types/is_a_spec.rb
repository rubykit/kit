require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::Types::IsA do

  let(:contract) { described_class[::String] }
  let(:args_valid) do
    [
      ['a'],
    ]
  end
  let(:args_invalid) do
    {
      [nil]         => 'IS_A failed: expected `` to be a `String`',
      [1]           => 'IS_A failed: expected `1` to be a `String`',
      [{ c: :ok, }] => 'IS_A failed: expected `{:c=>:ok}` to be a `String`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
