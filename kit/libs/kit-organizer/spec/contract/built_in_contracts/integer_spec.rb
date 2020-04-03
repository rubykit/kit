require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Integer do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [1],
      [9000000000000000000000000000],
    ]
  end
  let(:expected_type) { Integer }
  let(:args_invalid) do
    {
      [nil]                   => nil,
      [1.0]                   => nil,
      [::Kernel::Rational(1)] => nil,
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
