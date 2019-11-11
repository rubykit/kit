require_relative '../../rails_helper'
require_relative '../shared/types_exemples'
require_relative '../../../lib/kit/contract'

module TestModule
  def self.callable_method()
    true
  end

  class Functor
    def call()
      true
    end
  end
end

describe Kit::Contract::Types::Callable do

  let(:contract) { described_class }
  let(:args_valid) do
    [
      [->(v) { true }],
      [TestModule.method(:callable_method)],
      [TestModule::Functor.new],
    ]
  end
  let(:args_invalid) do
    {
      [nil] => 'RESPOND_TO failed: object does not respond_to `call`',
      [3]   => 'RESPOND_TO failed: object does not respond_to `call`',
    }
  end

  it_behaves_like 'a contract that succeeds on valid values'
  it_behaves_like 'a contract that fails on invalid values'

end
