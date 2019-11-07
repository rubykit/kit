require_relative '../rails_helper'
require_relative '../types_helper'
require_relative '../../lib/kit/contract'

describe Kit::Contract::Types::Rational do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [::Kernel::Rational(1)],
    ]
  end
  let(:args_invalid) do
    {
      [nil]                  => 'IS_A failed: expected `` to be a `Rational`',
      [1]                    => 'IS_A failed: expected `1` to be a `Rational`',
      [1.0]                  => 'IS_A failed: expected `1.0` to be a `Rational`',
      [::Kernel::Complex(1)] => 'IS_A failed: expected `1+0i` to be a `Rational`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
