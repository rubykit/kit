require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::Types::FalseClass do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [false],
    ]
  end
  let(:args_invalid) do
    {
      [true] => 'IS_A failed: expected `true` to be a `FalseClass`',
      [nil]  => 'IS_A failed: expected `` to be a `FalseClass`',
      [1]    => 'IS_A failed: expected `1` to be a `FalseClass`',
      ['1']  => 'IS_A failed: expected `1` to be a `FalseClass`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
