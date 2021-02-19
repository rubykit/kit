require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

describe Kit::Contract::BuiltInContracts::In do

  let(:contract) { described_class[1, '1', described_class[2, '2']] }
  let(:args_valid) do
    [
      { args: [1] },
      { args: ['1'] },
      { args: [2] },
      { args: ['2'] },
    ]
  end
  let(:args_invalid) do
    {
      { args: [nil] }        => 'IN failed: `` is not in `[1, "1", In[2, "2"]]`',
      { args: [4] }          => 'IN failed: `4` is not in `[1, "1", In[2, "2"]]`',
      { args: [{ c: :ok }] } => 'IN failed: `{:c=>:ok}` is not in `[1, "1", In[2, "2"]]`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
