require_relative '../rails_helper'
require_relative '../types_helper'
require_relative '../../lib/kit/contract'

describe Kit::Contract::Types::Boolean do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [true],
      [false],
    ]
  end
  let(:args_invalid) do
    {
      [nil] => 'OR failed',
      [1]   => 'OR failed',
      ['1'] => 'OR failed',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
