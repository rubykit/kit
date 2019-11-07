require_relative '../rails_helper'
require_relative '../types_helper'
require_relative '../../lib/kit/contract'

describe Kit::Contract::Types::TrueClass do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [true],
    ]
  end
  let(:args_invalid) do
    {
      [false] => 'IS_A failed: expected `false` to be a `TrueClass`',
      [nil]  => 'IS_A failed: expected `` to be a `TrueClass`',
      [1]    => 'IS_A failed: expected `1` to be a `TrueClass`',
      ['1']  => 'IS_A failed: expected `1` to be a `TrueClass`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
