require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Complex do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [Kernel::Complex(1)],
    ]
  end
  let(:args_invalid) do
    {
      [nil]                   => 'IS_A failed: expected `` to be a `Complex`',
      [1]                     => 'IS_A failed: expected `1` to be a `Complex`',
      [1.0]                   => 'IS_A failed: expected `1.0` to be a `Complex`',
      [::Kernel::Rational(1)] => 'IS_A failed: expected `1/1` to be a `Complex`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
