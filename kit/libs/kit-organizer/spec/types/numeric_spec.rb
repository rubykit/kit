require_relative '../rails_helper'
require_relative '../types_helper'
require_relative '../../lib/kit/contract'

describe Kit::Contract::Types::Numeric do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [1],
      [1.0],
      [::Kernel::Integer(1)],
      [::Kernel::Float(1)],
      [::Kernel::Rational(1)],
      [::Kernel::Complex(1)],
      [BigDecimal(1)],
    ]
  end
  let(:args_invalid) do
    {
      [nil] => 'IS_A failed: expected `` to be a `Numeric`',
      ['1'] => 'IS_A failed: expected `1` to be a `Numeric`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
