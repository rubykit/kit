require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::Types::Any do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [nil],
      [4],
      [[2]],
      [{ b: 2 }],
      [1..2],
      ['test'],
      [Object.new()],
    ]
  end

  it_behaves_like 'a contract that succeeds on valid values'

end
