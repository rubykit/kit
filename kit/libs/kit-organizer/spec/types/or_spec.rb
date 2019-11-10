require_relative '../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../lib/kit/contract'

describe Kit::Contract::Types::Or do

  let(:contract) { described_class[->(v) { v == 1 }, ->(v) { v == '1' }] }
  let(:args_valid) do
    [
      [1],
      ['1'],
    ]
  end
  let(:args_invalid) do
    {
      [nil]         => 'OR failed',
      [2]           => 'OR failed',
      [{ c: :ok, }] => 'OR failed',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
