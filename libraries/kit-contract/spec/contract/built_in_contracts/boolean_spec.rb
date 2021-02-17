require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::Boolean do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      { args: [true] },
      { args: [false] },
    ]
  end
  let(:args_invalid) do
    {
      { args: [nil] } => 'OR failed',
      { args: [1] }   => 'OR failed',
      { args: ['1'] } => 'OR failed',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
