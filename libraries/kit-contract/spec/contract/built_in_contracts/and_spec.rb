require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe ::Kit::Contract::BuiltInContracts::And do

  let(:contract) do
    described_class[
      ->(v) { v && v > 3 },
      ->(v) { v && v < 5 }
    ]
  end
  let(:args_valid) do
    [
      { args: [4] },
    ]
  end
  let(:args_invalid) do
    {
      { args: [nil] } => 'AND failed.',
      { args: [3] }   => 'AND failed.',
      { args: [5] }   => 'AND failed.',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
