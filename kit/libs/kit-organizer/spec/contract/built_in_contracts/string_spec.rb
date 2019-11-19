require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::String do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      ["a"],
    ]
  end
  let(:args_invalid) do
    {
      [nil] => 'IS_A failed: expected `` to be a `String`',
      [:a]  => 'IS_A failed: expected `a` to be a `String`',
      [1]   => 'IS_A failed: expected `1` to be a `String`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end