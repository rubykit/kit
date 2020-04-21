require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Numeric do

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
  let(:expected_type) { Numeric }
  let(:args_invalid) do
    {
      [nil] => nil,
      ['1'] => nil,
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
