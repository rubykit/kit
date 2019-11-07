require_relative '../rails_helper'
require_relative '../types_helper'
require_relative '../../lib/kit/contract'

describe Kit::Contract::Types::And do

  context 'Ordering combinations 1' do
    let(:contract) { described_class[->(v) { v && v > 3 }, ->(v) { v && v < 5 }] }
    let(:args_valid) do
      [
        [4],
      ]
    end
    let(:args_invalid) do
      {
        [nil] => 'AND failed',
        [3]   => 'AND failed',
        [5]   => 'AND failed',
      }
    end

    it_behaves_like 'a contract that succeeds on valid values'
    it_behaves_like 'a contract that fails on invalid values'
  end

end
