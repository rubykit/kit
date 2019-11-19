require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Float do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [0.0],
      [1.0],
      [Float::MAX],
      [Float::MIN],
      [Float::INFINITY],
      [Float::EPSILON],
    ]
  end
  let(:args_invalid) do
    {
      [nil] => 'IS_A failed: expected `` to be a `Float`',
      [1]   => 'IS_A failed: expected `1` to be a `Float`',
      ['1'] => 'IS_A failed: expected `1` to be a `Float`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
